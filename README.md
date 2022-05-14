# ThereminQ Tensors [ Work in Progress ]
![147117984-86c4b4b6-d55d-41ba-aab8-f056a6403902](https://user-images.githubusercontent.com/12692227/157748781-65b8bc1c-6be8-4f8e-b957-cb18027132e5.gif)

### CUDA-CLuster VDI with

- IBMQuantumExperience
- Qiskit
- Mitiq
- PyQrack
- SimulaQron
- Pennylane
- Tensor Board, Tensor Flow 2.x

## Run with Nvidia-Docker and/or Intel GPU Full VDI:
docker run --gpus all --privileged -p 6080:6080 --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors

![Screenshot from 2022-05-14 20-10-47](https://user-images.githubusercontent.com/12692227/168443646-35d34d39-b85b-4289-a8d7-a463c89ddc20.png)


## Shors' pyQrack 2-primes always-win-loop 
docker run --gpus all --privileged -p 6080:6080 --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors:shors

![Screenshot from 2022-05-14 20-08-34](https://user-images.githubusercontent.com/12692227/168443560-2b001178-0a5c-46aa-b151-ce856cf53804.png)

## CPU accelerated Full VDI:
docker run -p 6080:6080 -d twobombs/thereminq-tensors

## Minimum CPU kiosk VDI:
docker run -p 6080:6080 -d twobombs/thereminq-tensors:minimum

![Screenshot from 2022-05-11 21-21-17](https://user-images.githubusercontent.com/12692227/167929172-2101d17c-64da-4e75-9c81-d3063cf54171.png)


## Code from the following awesome companies and initiatives are in this container

![](https://user-images.githubusercontent.com/12692227/57654809-61c07f00-75d5-11e9-9005-38d60d8d4db4.png)

All rights and kudos belong to their respective owners. If (your) code resides in this container image and you don't want that please let me know.

Code of conduct : Contributor Covenant 
https://github.com/EthicalSource/contributor_covenant
