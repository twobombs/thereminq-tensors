# ThereminQ Tensors [ Work in Progress ]
![147117984-86c4b4b6-d55d-41ba-aab8-f056a6403902](https://user-images.githubusercontent.com/12692227/157748781-65b8bc1c-6be8-4f8e-b957-cb18027132e5.gif)

### CUDA-CLuster VDI with

- IBMQuantumExperience
- Qiskit
- Mitiq
- PyQrack
- SimulaQron
- Tensor Board, Tensor Flow 2.x

## Run with Nvidia-Docker and/or Intel GPU Full VDI:

docker run --gpus all --privileged -p 6080:6080 --device=/dev/dri:/dev/dri -d twobombs/thereminq-tensors

## CPU accelerated Full VDI:

docker run -p 6080:6080 -d twobombs/thereminq-tensors

## Minimum CPU Shell-only VDI:

docker run -p 6080:6080 -d twobombs/thereminq-tensors:minimum
