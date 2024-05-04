## ThereminQ Tensors - Jupyter notebooks, Shors' and TensorBoards
<img width="1000" alt="ThereminQ" src="https://github.com/twobombs/thereminq-tensors/assets/12692227/a299e650-6513-43d1-afab-ba036aa5e12e">


### CUDA-CLuster VDI

PyQrack & Qiskit Jupyter Notebooks in `:latest` <br>
Shors' Algorithm Analysis with Qimcifa and pyQrack in `:shors` <br>
Tensor Board, Tensor Flow data analisys in `:boards` <br>
Metal, Qiskit Metal and IQM KQCircuits design in `:metal` 
AgentOPS on Open Interpreter UI and Ollama in `:agent`

Plugins / Connectors / Jupyter NoteBooks
- SimulaQron            http://www.simulaqron.org/
- Mitiq                 https://mitiq.readthedocs.io/en/stable/
- Cirq                  https://quantumai.google/cirq
- Qiskit-qrack-provider https://github.com/vm6502q/qiskit-qrack-provider
- IBMQuantumExperience  https://quantum-computing.ibm.com/
- QUDA                  http://lattice.github.io/quda/
- cuQuantum             https://developer.nvidia.com/cuquantum-sdk
- IQM KQCircuits        https://github.com/iqm-finland/KQCircuits

The following Python repos are included, converted to Jupyter when needed
- https://github.com/vm6502q/pyqrack-jupyter.git 
- https://github.com/twobombs/thereminq-tensors.git
- https://github.com/vm6502q/simulator-benchmarks.git
- https://github.com/quantumlib/Cirq.git
- https://github.com/vm6502q/qiskit-qrack-provider.git
- https://github.com/unitaryfund/mitiq.git
- https://github.com/NVIDIA/cuQuantum.git

## Run with Nvidia-Docker and/or Intel GPU Full VDI:
```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:tag
````

## Shors' RSA SSH Keypair factorization and 2-primes test loop 
![Screenshot from 2022-05-14 20-10-47](https://user-images.githubusercontent.com/12692227/168443646-35d34d39-b85b-4289-a8d7-a463c89ddc20.png)
Python Jupyter PyQrack & Qiskit environment

```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:shors
````
## Interactive Qiskit Metal and KQCircuits 
![Screenshot from 2024-04-14 17-03-08](https://github.com/twobombs/thereminq-tensors/assets/12692227/5c717466-459e-4bef-b739-c0e699069d82)


Metal, Qiskit Metal and IQM KQCircuits environment

```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:metal
````
## QIMCIFA and RSA Certificate generation
![Screenshot from 2022-05-22 20-43-30](https://user-images.githubusercontent.com/12692227/169710747-32ef4926-0286-487a-b9ed-e8c676b2a43a.png)
Shors' with 
- rsaConverter https://www.idrix.fr/Root/content/category/7/28/51/
- Qimcifa https://github.com/vm6502q/qimcifa

```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:qimcifa
````

## Ollama Open Interpreter Agent stack for coding solutions
![Screenshot from 2024-05-04 12-54-37](https://github.com/twobombs/thereminq-tensors/assets/12692227/318b1e55-5fee-4c57-9642-4b13f43affc7)
- Ollama https://ollama.com
- Open Interpreter https://www.openinterpreter.com/
- Open Interpreter UI https://github.com/blazzbyte/OpenInterpreterUI

```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:agent
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
