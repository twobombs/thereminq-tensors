## ThereminQ Tensors - Jupyter notebooks, Shors' and TensorBoards
<img width="200" alt="ThereminQ" src="https://user-images.githubusercontent.com/12692227/147117984-86c4b4b6-d55d-41ba-aab8-f056a6403902.gif">

Note: because of incompatibilities with the new `CUDA 12.x` image and Python requirements for CirQ and Qiskit the `NoVNC` functionality has been disabled on this repo; remote access is still provided through VNC on port `5900` and RDP on `3389`. When these issues are resolved the NoVNC functionality will return. The other ThereminQ container images are not affected.

### CUDA-CLuster VDI

PyQrack & Qiskit Jupyter Notebooks in :latest <br>
Shors' Algorithm Analysis in :shors <br>
Tensor Board, Tensor Flow in :boards [work in progress]<br>

Plugins / Connectors / Jupyter NoteBooks
- SimulaQron            http://www.simulaqron.org/
- Mitiq                 https://mitiq.readthedocs.io/en/stable/
- Cirq                  https://quantumai.google/cirq
- Qiskit-qrack-provider https://github.com/vm6502q/qiskit-qrack-provider
- IBMQuantumExperience  https://quantum-computing.ibm.com/
- QUDA                  http://lattice.github.io/quda/
- cuQuantum             https://developer.nvidia.com/cuquantum-sdk

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

![Screenshot from 2022-05-14 20-10-47](https://user-images.githubusercontent.com/12692227/168443646-35d34d39-b85b-4289-a8d7-a463c89ddc20.png)
Python Jupyter PyQrack & Qiskit environment

## Shors' RSA SSH Keypair factorization and 2-primes test loop 
```bash
docker run --gpus all --privileged -p 6080:6080 --ipc=host --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:shors
````

![Screenshot from 2022-05-22 20-43-30](https://user-images.githubusercontent.com/12692227/169710747-32ef4926-0286-487a-b9ed-e8c676b2a43a.png)
C-style Shors' with rsaConverter ( https://www.idrix.fr/Root/content/category/7/28/51/) and Qimcifa ( https://github.com/vm6502q/qimcifa )

## CPU accelerated the same VDI:
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
