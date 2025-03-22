# original created by Dan Strano of the Unitary fund 
# https://github.com/vm6502q/pyqrack-examples/blob/main/vqe.py
# plot was added by Qwen2.5-Coder-32B-Instruct-Q5_K_S.gguf
# multithreading for workers and gradient clusters by gemini2
# experimental code - can change without notice
# very high memory usage per thread 

import multiprocessing
import os

# All imports MUST be at the top level for spawn to work correctly.
import pennylane as qml
from pennylane import numpy as np
import openfermion as of
from openfermionpyscf import run_pyscf
from openfermion.transforms import bravyi_kitaev  # Or jordan_wigner, if you prefer
import matplotlib.pyplot as plt
import time
import cProfile
import pstats

# --- Parallelized Hamiltonian Construction ---
def compute_hamiltonian(args):
    """
    Unpacks arguments and computes the Hamiltonian.
    """
    geometry, basis, multiplicity, charge = args
    molecule = of.MolecularData(geometry, basis, multiplicity, charge)
    molecule = run_pyscf(molecule, run_scf=True, run_fci=True)
    fermionic_hamiltonian = molecule.get_molecular_hamiltonian()
    qubit_hamiltonian = bravyi_kitaev(fermionic_hamiltonian)  # Or jordan_wigner(fermionic_hamiltonian)
    n_qubits = molecule.n_qubits

    coeffs = []
    observables = []
    for term, coefficient in qubit_hamiltonian.terms.items():
        pauli_operators = []
        for qubit_idx, pauli in term:
            if pauli == 'X':
                pauli_operators.append(qml.PauliX(qubit_idx))
            elif pauli == 'Y':
                pauli_operators.append(qml.PauliY(qubit_idx))
            elif pauli == 'Z':
                pauli_operators.append(qml.PauliZ(qubit_idx))
        if pauli_operators:
            observable = pauli_operators[0]
            for op in pauli_operators[1:]:
                observable = observable @ op
            observables.append(observable)
        else:
            observables.append(qml.Identity(0))
        coeffs.append(qml.numpy.array(coefficient, requires_grad=False))

    hamiltonian = qml.Hamiltonian(coeffs, observables)
    return hamiltonian, n_qubits


# Ansatz definition
def ansatz(params, wires):
    for i in range(len(wires)):
        qml.Hadamard(wires=i)
        qml.RZ(params[i], wires=i)
        qml.Hadamard(wires=i)
    for i in range(len(wires) - 1):
        qml.CNOT(wires=[i, i + 1])


if __name__ == '__main__':
    multiprocessing.set_start_method('spawn')
    print(f"Multiprocessing start method: {multiprocessing.get_start_method()}")

# Before running: Set environment variables
# On command line or by .env file, you can set the following variables
# QRACK_DISABLE_QUNIT_FIDELITY_GUARD=1: For large circuits, automatically "elide," for approximation
# QRACK_NONCLIFFORD_ROUNDING_THRESHOLD=[0 to 1]: Sacrifices near-Clifford accuracy to reduce overhead
# QRACK_QUNIT_SEPARABILITY_THRESHOLD=[0 to 1]: Rounds to separable states more aggressively
# QRACK_QBDT_SEPARABILITY_THRESHOLD=[0 to 0.5]: Rounding for QBDD, if actually used

    os.environ['OMP_NUM_THREADS'] = '1'  # thread safety - higher then 1 will influence outcome
    os.environ['QRACK_DISABLE_QUNIT_FIDELITY_GUARD'] = '1'
#    os.environ[''] = '1'


    # Basis set and molecule definition for UF6
    basis = {'U': 'lanl2dz', 'F': '6-31G(d)'}
    multiplicity = 1
    charge = 0
    geometry = [
        ('U', (0.0, 0.0, 0.0)),
        ('F', (1.996, 0.0, 0.0)),
        ('F', (-1.996, 0.0, 0.0)),
        ('F', (0.0, 1.996, 0.0)),
        ('F', (0.0, -1.996, 0.0)),
        ('F', (0.0, 0.0, 1.996)),
        ('F', (0.0, 0.0, -1.996)),
    ]

    def main():

        # --- Parallel Hamiltonian Computation ---
        with multiprocessing.Pool() as pool:
            hamiltonian, n_qubits = pool.map(compute_hamiltonian, [(geometry, basis, multiplicity, charge)])[0]

        print(f"{n_qubits} qubits...")

        # Use qrack.simulator, enable GPU if available
        dev = qml.device("qrack.simulator", wires=n_qubits, gpu=True) # Try with and without gpu=True

        @qml.qnode(dev, diff_method="parameter-shift")  # Use parameter-shift with Qrack
        def circuit(params):
            ansatz(params, wires=range(n_qubits))
            return qml.expval(hamiltonian)


        # VQE optimization loop
        opt = qml.AdamOptimizer(stepsize=0.02)
        theta = np.random.randn(n_qubits, requires_grad=True)
        num_steps = 200
        batch_size = 5  # Start with batch_size=1 for Qrack.  Experiment! ( set to 5 )

        energy_history = []
        start_time = time.time()
        grad_fn = qml.grad(circuit, argnum=0)

        for step in range(num_steps):
            grads = grad_fn(theta)  # Gradients with Qrack + parameter-shift
            theta = opt.apply_grad(grads, theta)
            energy = circuit(theta)
            energy_history.append(energy)
            print(f"Step {step + 1}: Energy = {energy} Ha")

        end_time = time.time()
        print(f"Optimized Ground State Energy: {energy_history[-1]} Ha")
        print("Optimized parameters:")
        print(theta)
        print(f"Total optimization time: {end_time - start_time:.2f} seconds")

        plt.plot(range(1, len(energy_history) + 1), energy_history, marker='o')
        plt.title('Energy vs Optimization Steps')
        plt.xlabel('Step')
        plt.ylabel('Energy (Hartrees)')
        plt.grid(True)
        plt.show()

    # Profile the main execution
    with cProfile.Profile() as pr:
        main()

    stats = pstats.Stats(pr)
    stats.sort_stats(pstats.SortKey.TIME)
    stats.print_stats(20)
    # stats.dump_stats("profile_results_qrack.prof") # Optional

