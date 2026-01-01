<img width="1536" height="1024" alt="ChatGPT Image Jan 1, 2026, 12_55_47 PM" src="https://github.com/user-attachments/assets/64036380-01d8-4b3a-9152-eff641577d4c" />

# ThereminQ-Tensors

## About

ThereminQ-Tensors is a comprehensive suite of Docker images designed for quantum computing research and development. It provides a VDI (Virtual Desktop Infrastructure) environment with a wide range of pre-installed tools and libraries, including pyQrack, Qiskit, Cirq, and Mitiq. The project aims to provide a reproducible and easy-to-use environment for running and controlling quantum circuits.

This project is especially useful for researchers and developers who need a consistent and portable environment for their quantum computing experiments. It eliminates the need to manually install and configure a complex toolchain, allowing you to focus on your research.

## Features

* **Comprehensive Tooling:** Includes a wide range of popular quantum computing libraries and tools, such as:
    * **pyQrack:** A Python wrapper for the Qrack quantum computing simulator.
    * **Qiskit:** An open-source quantum computing software development framework.
    * **Cirq:** A Python library for writing, manipulating, and optimizing quantum circuits.
    * **Mitiq:** A Python toolkit for implementing error mitigation on quantum computers.
    * **And many more!**
* **GPU Acceleration:** Supports AMD, NVIDIA and Intel GPUs for accelerated quantum circuit simulation.
* **VDI Environment:** Provides a full VDI environment with a graphical user interface, accessible via VNC or RDP.
* **Jupyter Notebooks:** Includes a variety of Jupyter Notebooks for data analysis, quantum circuit design, and machine learning.
* **Agentic Development:** Integrates with Gemini CLI and Open Interpreter to assist with development and migration to Qiskit 2.x.
* **Specialized Images:** Offers a variety of specialized Docker images for different use cases, such as:
    * **`:qml`:** Includes QML Jupyter notebooks.
    * **`:jupyter`:** Jupyter notebook-based data analysis.
    * **`:metal`:** Qiskit Metal and IQM KQCircuits design.
    * **`:agent`:** Adds AgentOPS with Open Interpreter UI.
    * **`:shors`:** PoC Shor's Algorithm Analysis with Qimcifa and pyQrack.
    * **`:bench`:** For Zapata BenchQ and yarkstiq Quantum-benchmark.

## Getting Started

### Prerequisites

* Docker
* NVIDIA Docker (for GPU acceleration)

### Installation

To get started with ThereminQ-Tensors, you can pull the latest Docker image from Docker Hub:

```bash
docker pull twobombs/thereminq-tensors:latest
```

You can also pull a specific image by specifying the tag:

```bash
docker pull twobombs/thereminq-tensors:<tag>
```

## Usage

### Running the VDI Environment

To run the VDI environment, you can use the following command:

```bash
docker run --gpus all --device=/dev/kfd --device=/dev/dri:/dev/dri -p 6080:6080 -d twobombs/thereminq-tensors:latest
```

This will start the VDI environment and make it accessible at `http://localhost:6080`. The default VNC password is `00000000`.

### Accessing the VDI Environment

You can access the VDI environment in two ways:

* **noVNC:** Open your web browser and navigate to `http://localhost:6080`.
* **xRDP:** Connect to the VDI environment using an RDP client at `localhost:3389`.

### Specialized Images

ThereminQ-Tensors provides a variety of specialized Docker images for different use cases. Here is a list of the available images and their corresponding tags:

| Tag | Description |
|---|---|
| `:latest` | Ollama powered PyQrack & Qiskit Jupyter Notebooks |
| `:qml` | Includes QML Jupyter notebooks |
| `:jupyter` | Jupyter notebook based data analysis |
| `:metal` | Qiskit Metal and IQM KQCircuits design |
| `:agent` | Adds AgentOPS with Open Interpreter UI |
| `:shors` | PoC Shors' Algorithm Analysis with Qimcifa and pyQrack |
| `:bench` | For Zapata BenchQ and yarkstiq Quantum-benchmark |

To run a specialized image, simply replace the `:latest` tag with the desired tag in the `docker run` command. For example, to run the QML image, you would use the following command:

```bash
docker run --gpus all --device=/dev/kfd --device=/dev/dri:/dev/dri -p 6080:6080 -d twobombs/thereminq-tensors:qml
```

## Contributing

Contributions to ThereminQ-Tensors are welcome! We value a friendly and welcoming community. Please read our [Code of Conduct](CODE_OF_CONDUCT.md) to understand our community standards.

If you would like to contribute, please fork the repository and submit a pull request.

## License

ThereminQ-Tensors is licensed under the GNU General Public License v3.0 or later. See the [LICENSE](LICENSE) file for more information.

## Acknowledgments

This project was created by Aryan Jacques Blaauw. If you use this software in your research, please cite it using the following information:

```
@software{Blaauw_ThereminQ_2023,
author = {Blaauw, Aryan Jacques},
doi = {10.48550/ARXIV.2304.14969},
month = {5},
title = {{ThereminQ}},
url = {https://github.com/twobombs/thereminq},
year = {2023}
}
```

This project would not be possible without the contributions of the open-source community. We would like to thank the developers of the following projects for their hard work and dedication:

* [pyQrack](https://github.com/unitaryfund/pyqrack)
* [Mitiq](https://mitiq.readthedocs.io/en/stable/)
* [Cirq](https://quantumai.google/cirq)
* [Qiskit](https://www.ibm.com/quantum/qiskit)
* [And many more!](https://github.com/twobombs/thereminq-tensors/blob/main/Dockerfiles/Dockerfile)
