# original created by Dan Strano of the Unitary fund 
# https://github.com/vm6502q/pyqrack-examples/blob/main/vqe.py
# plot was added by Qwen2.5-Coder-32B-Instruct-Q5_K_S.gguf
# multithreading for workers and gradient clusters by gemini2
# experimental code - can change without notice
#
import pennylane as qml
from pennylane import numpy as np
import openfermion as of
from openfermionpyscf import run_pyscf
from openfermion.transforms import jordan_wigner
import matplotlib.pyplot as plt
import multiprocessing
import time
import os

# Step 1: Define the molecule - H2 in example
geometry = [('H', (0.0, 0.0, 0.0)), ('H', (0.0, 0.0, 0.74))]

basis = 'sto-3g'
multiplicity = 1
charge = 0

# Step 2: Compute the Molecular Hamiltonian
molecule = of.MolecularData(geometry, basis, multiplicity, charge)
molecule = run_pyscf(molecule, run_scf=True, run_fci=True)
fermionic_hamiltonian = molecule.get_molecular_hamiltonian()

# Step 3: Convert to Qubit Hamiltonian
qubit_hamiltonian = jordan_wigner(fermionic_hamiltonian)

# Step 4: Extract Qubit Terms for PennyLane
coeffs = []
observables = []
n_qubits = molecule.n_qubits
print(str(n_qubits) + " qubits...")

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

# Step 5: Define PennyLane Device (Qrack GPU)
dev = qml.device("qrack.simulator", wires=n_qubits, isTensorNetwork=False, gpu=True)


# Step 6: Define a Simple Variational Ansatz
def ansatz(params, wires):
    for i in range(len(wires)):
        qml.Hadamard(wires=i)
        qml.RZ(params[i], wires=i)
        qml.Hadamard(wires=i)
    for i in range(len(wires) - 1):
        qml.CNOT(wires=[i, i + 1])

# Step 7: Cost Function for VQE
@qml.qnode(dev)
def circuit(params):
    ansatz(params, wires=range(n_qubits))
    return qml.expval(hamiltonian)

def optimize_step(step, theta, opt):
    # NOTE: We don't actually USE the opt here.
    energy = circuit(theta)  # Only calculate the energy
    return step + 1, theta, energy

def main():
    # Step 8: Optimize the Energy (Multiprocessing + Batched Updates)
    opt = qml.AdamOptimizer(stepsize=0.02)
    theta = np.random.randn(n_qubits, requires_grad=True)
    num_steps = 200
    batch_size = 4  # Accumulate gradients over 'batch_size' steps - multithreading clustering on the gradient cluster speedup

    energy_history = []

    start_time = time.time()
    num_processes = multiprocessing.cpu_count()    # take the maximum number of threads on the CPU, small molecules wont use a lot of CPU per worker
    print(f"Using {num_processes} processes.")

    accumulated_grads = None

    with multiprocessing.Pool(processes=num_processes) as pool:
        results = []
        for step in range(num_steps):
            results.append(pool.apply_async(optimize_step, args=(step, theta.copy(), opt)))
            # Accumulate gradients
            if (step + 1) % batch_size == 0 or step == num_steps -1 :
                #collect all the results
                for result in results:
                    step_num, _, energy = result.get()
                    energy_history.append(energy)
                    print(f"Step {step_num}: Energy = {energy} Ha")

                #calculate the derivative of the circuit.
                grad_fn = qml.grad(circuit, argnum=0)
                grads = grad_fn(theta)

                if accumulated_grads is None:
                    accumulated_grads = grads
                else:
                    # Accumulate gradients correctly (element-wise addition)
                    accumulated_grads = [ag + g for ag, g in zip(accumulated_grads, grads)]

                theta = opt.apply_grad(accumulated_grads, theta) # Corrected line

                accumulated_grads = None #reset
                results = [] #reset

        pool.close()
        pool.join()

    end_time = time.time()

    print(f"Optimized Ground State Energy: {energy_history[-1]} Ha")
    print("Optimized parameters:")
    print(theta)
    print(f"Total optimization time: {end_time - start_time:.2f} seconds")

    # Step 9: Plot the Energy History
    plt.plot(range(1, len(energy_history) + 1), energy_history, marker='o')
    plt.title('Energy vs Optimization Steps')
    plt.xlabel('Step')
    plt.ylabel('Energy (Hartrees)')
    plt.grid(True)
    plt.show()

if __name__ == "__main__":
    main()
