# Angular Container Deployment - CI Guide - Windows OS

## 1. Docker Setup

### Installing Docker
- **Windows:** Download and install Docker Desktop from [Docker](https://www.docker.com/products/docker-desktop/)

### Additional Dependencies
- **Windows:** Requires WSL2 with a Linux distribution (Ubuntu is recommended)
- **Linux/macOS:** No additional dependencies required

### Confirming Docker Installation
To verify Docker is installed correctly (command prompt/powershell):
```bash
docker --version
```

To confirm the Docker is running and containers work:
```
docker run hello-world
```
## 2. Manually Setting up a Container
Running a Container for Angular App Testing:
```
docker run -it -v ${PWD}/angular-site:/app -w /app -p 4200:4200 node:18-bullseye bash
```

Explanation of Flags:

`-it`: Interactive terminal

`-v`: Mounts the local directory into the container

`-w`: Sets working directory inside container

`-p`: Maps container port 4200 to host port 4200

Commands Inside the Container
Install Angular CLI and dependencies:
```
npm install -g @angular/cli
npm install
```

Build the Angular application:
```
ng build --configuration production
```

Install HTTP server and serve the app:
```
npm install -g http-server
http-server dist/YOUR_APP_NAME -p 4200
```
Replace `YOUR_APP_NAME` with your actual build folder name.

### Validation
Container side: Confirm http-server reports listening on `http://127.0.0.1:4200`

Host side: Visit [http://localhost:4200](http://localhost:4200) in a browser
