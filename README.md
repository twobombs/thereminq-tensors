## ThereminQ Tensors - Jupyter notebooks, Shors' and TensorBoards
<img width="200" alt="ThereminQ" src="https://user-images.githubusercontent.com/12692227/147117984-86c4b4b6-d55d-41ba-aab8-f056a6403902.gif">

### CUDA-CLuster VDI

PyQrack & Qiskit Jupyter Notebooks in :latest <br>
Shors' Algorithm Analysis in :shors <br>
Tensor Board, Tensor Flow in :boards [work in progress]<br>

Plugins / Connectors
- SimulaQron
- Mitiq / Cirq
- Qiskit-qrack-provider
- IBMQuantumExperience

## Run with Nvidia-Docker and/or Intel GPU Full VDI:
docker run --gpus all --privileged -p 6080:6080 --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:<tag>

![Screenshot from 2022-05-14 20-10-47](https://user-images.githubusercontent.com/12692227/168443646-35d34d39-b85b-4289-a8d7-a463c89ddc20.png)

## Shors' RSA SSH Keypair factorization and 2-primes test loop 
docker run --gpus all --privileged -p 6080:6080 --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:shors

![Screenshot from 2022-05-14 20-08-34](https://user-images.githubusercontent.com/12692227/168443560-2b001178-0a5c-46aa-b151-ce856cf53804.png)

## CPU accelerated Full VDI:
docker run -p 6080:6080 -d twobombs/thereminq-tensors

## Minimum CPU-only Jupyter notebook kiosk VDI:
docker run -p 6080:6080 -d twobombs/thereminq-tensors:minimum

## Code from the following awesome companies and initiatives are in this container

![](https://user-images.githubusercontent.com/12692227/57654809-61c07f00-75d5-11e9-9005-38d60d8d4db4.png)

All rights and kudos belong to their respective owners. <br>
If (your) code resides in this container image and you don't want that please let me know. <br>

Code of conduct : Contributor Covenant 
https://github.com/EthicalSource/contributor_covenant
