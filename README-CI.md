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

## 3. Dockerfile & Building Images
### Dockerfile Overview

Recall Step 2 as we are now performing the same actions, but this time within a `dockerfile`.

dockerfile
```
FROM node:18-bullseye
WORKDIR /app
COPY wsu-hw-ng-main/ .
RUN npm install -g @angular/cli \
    && npm install \
    && ng build --configuration production \
    && npm install -g http-server
CMD ["http-server", "dist/YOUR_APP_NAME", "-p", "4200"]
```

### Summary:

- Uses Node 18 base image

- Copies the Angular project into the container

- Installs Angular CLI and app dependencies

- Builds the Angular app

- Uses http-server to serve the build

Building the Image:
```
docker build -t yourdockerhubusername/projectname .
```

Run the Container from Image:
```
docker run -p 4200:4200 yourdockerhubusername/projectname
```

### Validation
Container side: http-server should output available URLs

Host side: Visit [http://localhost:4200](http://localhost:4200) to confirm app is live

## 4. Working with your DockerHub Repository
### Create a Public Repository
Go to [https://hub.docker.com](https://hub.docker.com)

Create a new repository with:

Visibility: Public

Name: `<yourlastname>-CEG3120`

Create a Personal Access Token (PAT)
Go to [https://app.docker.com/settings/personal-access-tokens](https://app.docker.com/settings/personal-access-tokens)

Click `Generate New Token`

Set scope to Read/Write

Copy the token and save it somewhere safe (you won’t see it again)

Authenticate to DockerHub via CLI
```
docker login -u YOUR-USERNAME
```
```
Password: your PAT (not your account password & assuming you saved it somewhere safe)
```

Push Image to DockerHub
```
docker push yourdockerhubusername/projectname
```

Repository Link
```
https://hub.docker.com/repository/docker/YOUR_DOCKERHUB_USERNAME/YOUR_REPO_NAME
```
