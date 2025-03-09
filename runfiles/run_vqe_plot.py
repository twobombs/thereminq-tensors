import pennylane as qml
from pennylane import numpy as np
import openfermion as of
from openfermionpyscf import run_pyscf
from openfermion.transforms import jordan_wigner
import matplotlib.pyplot as plt

# Step 1: Define the molecule (Hydrogen, Helium, Lithium, Nitrogen, Oxygen)
geometry = [('H', (0.0, 0.0, 0.0)), ('H', (0.0, 0.0, 0.74))]  # H2 Molecule
basis = 'sto-3g'  # Minimal Basis Set
multiplicity = 1  # singlet, closed shell, all electrons are paired (neutral molecules with full valence)
charge = 0  # Excess +/- elementary charge, beyond multiplicity

# Step 2: Compute the Molecular Hamiltonian
molecule = of.MolecularData(geometry, basis, multiplicity, charge)
molecule = run_pyscf(molecule, run_scf=True, run_fci=True)
fermionic_hamiltonian = molecule.get_molecular_hamiltonian()

# Step 3: Convert to Qubit Hamiltonian (Jordan-Wigner)
qubit_hamiltonian = jordan_wigner(fermionic_hamiltonian)

# Step 4: Extract Qubit Terms for PennyLane
coeffs = []
observables = []
n_qubits = molecule.n_qubits  # Auto-detect qubit count
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
        observables.append(qml.Identity(0))  # Default identity if no operators
    coeffs.append(qml.numpy.array(coefficient, requires_grad=False))

hamiltonian = qml.Hamiltonian(coeffs, observables)

# Step 5: Define Qrack Backend
dev = qml.device("qrack.simulator", wires=n_qubits, isTensorNetwork=False)  # Replace with "default.qubit" for CPU test

# Step 6: Define a Simple Variational Ansatz
def ansatz(params, wires):
    for i in range(len(wires)):
        qml.Hadamard(wires=i)
        qml.RZ(params[i], wires=i)
        qml.Hadamard(wires=i)
    for i in range(len(wires) - 1):
        qml.CNOT(wires=[i, i + 1])

# Step 7: Cost Function for VQE (Expectation of Hamiltonian)
@qml.qnode(dev)
def circuit(params):
    ansatz(params, wires=range(n_qubits))
    return qml.expval(hamiltonian)  # Scalar cost function

# Step 8: Optimize the Energy
opt = qml.AdamOptimizer(stepsize=0.02)
theta = np.random.randn(n_qubits, requires_grad=True)
num_steps = 200

# Store energy values for plotting
energy_history = []

for step in range(num_steps):
    theta = opt.step(circuit, theta)
    energy = circuit(theta)  # Compute energy at new parameters
    energy_history.append(energy)
    print(f"Step {step+1}: Energy = {energy} Ha")

print(f"Optimized Ground State Energy: {energy} Ha")
print("Optimized parameters:")
print(theta)

# Step 9: Plot the Energy History
plt.plot(range(1, num_steps + 1), energy_history, marker='o')
plt.title('Energy vs Optimization Steps')
plt.xlabel('Step')
plt.ylabel('Energy (Hartrees)')
plt.grid(True)
plt.show()
