# Angular Container Deployment - CI Guide

## Docker Setup

### Installing Docker
- **Windows:** Download and install Docker Desktop from [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- **Linux:** Use the system package manager (e.g., `apt install docker.io` for Debian/Ubuntu)
- **Mac:** Use Docker Desktop for macOS

### Additional Dependencies
- **Windows:** Requires WSL2 with a Linux distribution (Ubuntu is recommended)
- **Linux/macOS:** No additional dependencies required

### Confirming Docker Installation
To verify Docker is installed correctly:
```bash
docker --version
