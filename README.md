## ThereminQ-Tensors 
### Run & Control Quantum Circuits with Agentic Jupyter Notebooks

<img width="1969" height="1435" alt="thereminq-resize" src="https://github.com/user-attachments/assets/2f50cca5-3c46-4445-a4da-a0d750375240" />


As the Qiskit 2.x migration makes progress this stack will remain in development mode

- Agency is now by default installed and enabled in both the jupyter and agent container images
- Gemini CLI and Open Interpreter now assist development during and after the migration process
- According to the IBM roadmap the Qiskit 2.x move should be concluded at the end of 2025, early 2026

 disclaimer:
* even though I've taken steps above and beyond what is currently known to be best practices for AI Agency
* any liabilities and/or damages resulting from the use of Agentic Tech in this container image is solely for the user

Agency will remain integrated from now on and is no longer considered beta after 1.5 years of evaluation

### CUDA-CLuster VDI

`:latest` Ollama powered PyQrack & Qiskit Jupyter Notebooks<br>
`:qml` includes QML Jupyter notebooks <br>
`:jupyter` Jupyter notebook based data analysis <br>
`:metal` Qiskit Metal and IQM KQCircuits design <br>
`:agent` adds AgentOPS with Open Interpreter UI <br>
`:shors` PoC Shors' Algorithm Analysis with Qimcifa and pyQrack <br>
`:bench` for Zapata BenchQ and yarkstiq Quantum-benchmark

Plugins / Connectors / Jupyter NoteBooks
- pyQrack               https://github.com/unitaryfund/pyqrack
- Mitiq                 https://mitiq.readthedocs.io/en/stable/
- Cirq                  https://quantumai.google/cirq
- Qiskit                https://www.ibm.com/quantum/qiskit
- Qiskit-qrack-provider https://github.com/vm6502q/qiskit-qrack-provider
- IBMQuantumExperience  https://quantum-computing.ibm.com/
- QUDA                  http://lattice.github.io/quda/
- cuQuantum             https://developer.nvidia.com/cuquantum-sdk
- IQM KQCircuits        https://github.com/iqm-finland/KQCircuits
- BenchQ                https://github.com/zapatacomputing/benchq
- Quantum-benchmark     https://github.com/yardstiq/quantum-benchmarks.git

The following Python repos are included - converted to Jupyter Notebook or vv
- https://github.com/vm6502q/pyqrack-jupyter.git 
- https://github.com/twobombs/thereminq-tensors.git
- https://github.com/vm6502q/simulator-benchmarks.git
- https://github.com/quantumlib/Cirq.git
- https://github.com/vm6502q/qiskit-qrack-provider.git
- https://github.com/unitaryfund/mitiq.git
- https://github.com/NVIDIA/cuQuantum.git
- https://github.com/tensorflow/quantum.git

## Run with Nvidia-Docker and/or Intel GPU Full VDI

```bash
docker run --gpus all --device=/dev/kfd --device=/dev/dri:/dev/dri  [--ipc=host]  [--privileged] -p 6080:6080 -d twobombs/thereminq-tensors:tag
````

## Jupyter Notebooks UI
<img width="1697" height="963" alt="Screenshot from 2025-07-19 17-01-18" src="https://github.com/user-attachments/assets/33b6f5f5-32de-47f2-ae96-75b1dd68ffb5" />

![Screenshot from 2024-06-15 10-15-29](https://github.com/twobombs/thereminq-tensors/assets/12692227/401fedd8-78f9-4773-ac68-85808abc97ad)

## Create and/or run Python Quantum-inspired Graphs
![Screenshot from 2025-01-05 14-27-02](https://github.com/user-attachments/assets/dab8a43b-c974-4fd5-b4a3-7dbf3d61960e)

## Simulate and visualize Sycamore/Willow circuits up to and beyond 105 qubits
![Screenshot_from_2025-01-06_19-47-23](https://github.com/user-attachments/assets/a887d0c6-be0b-4c94-abd0-8ee185d26e76)


```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:jupyter[-pocl]
````

## Ollama Open Interpreter AgentOPS stack for coding solutions
![Screenshot from 2024-05-04 12-54-37](https://github.com/twobombs/thereminq-tensors/assets/12692227/318b1e55-5fee-4c57-9642-4b13f43affc7)

- Ollama https://ollama.com
- Open Interpreter https://www.openinterpreter.com/
- Open Interpreter UI https://github.com/blazzbyte/OpenInterpreterUI

```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:agent
````

## Shors' RSA SSH Keypair factorization and 2-primes test loop 
![Screenshot from 2022-05-14 20-10-47](https://user-images.githubusercontent.com/12692227/168443646-35d34d39-b85b-4289-a8d7-a463c89ddc20.png)

## QIMCIFA, Find-A-Factor and RSA Certificate generation
![Screenshot from 2022-05-22 20-43-30](https://user-images.githubusercontent.com/12692227/169710747-32ef4926-0286-487a-b9ed-e8c676b2a43a.png)
Shors' with 
- rsaConverter https://www.idrix.fr/Root/content/category/7/28/51/
- Qimcifa https://github.com/vm6502q/qimcifa
- Find-A-Factor https://github.com/vm6502q/findafactor


```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:shors
````


## Interactive Qiskit Metal and KQCircuits 
![Screenshot from 2024-04-14 17-03-08](https://github.com/twobombs/thereminq-tensors/assets/12692227/5c717466-459e-4bef-b739-c0e699069d82)

https://youtu.be/NxArWX8WhPc 

```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:metal
````


## CPU only accelerated vanilla VDI:
```bash
docker run -p 6080:6080 -d twobombs/thereminq-tensors
````

## Minimalistic CPU-only Jupyter notebook kiosk VDI:
```bash
docker run -p 6080:6080 -d twobombs/thereminq-tensors:minimum
````

Initial vnc password is `00000000`
- VNC port avaliable on `5900`
- noVNC website is avaliable at port `6080` 
- xRDP running at port `3389` proxy to vnc `127.0.0.1:5900`

## Code from the following awesome companies and initiatives are in this container

![](https://user-images.githubusercontent.com/12692227/57654809-61c07f00-75d5-11e9-9005-38d60d8d4db4.png)

All rights and kudos belong to their respective owners. <br>
If (your) code resides in this container image and you don't want that please let me know. <br>

Code of conduct : Contributor Covenant 
https://github.com/EthicalSource/contributor_covenant
