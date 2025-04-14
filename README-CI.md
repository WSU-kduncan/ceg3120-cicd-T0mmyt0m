# Angular Container Deployment - CI Guide - Windows OS

# Part 1

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
Password: your PAT (not your account password & assuming you saved it somewhere safe)

Push Image to DockerHub
```
docker push yourdockerhubusername/projectname
```

Repository Link

[https://hub.docker.com/r/tummyz0/pua-ceg3120](https://hub.docker.com/r/tummyz0/pua-ceg3120)

# Part 2

## Configuring GitHub Repository Secrets

### 1. Creating a DockerHub Personal Access Token (PAT)
- Go to [DockerHub Security Settings](https://hub.docker.com/settings/security)
- Click **Generate New Token**
- Name it something you like
- **Recommended Scope**: `Read/Write` (needed to push images)
- Copy the token — you won't see it again!!!

### 2. Setting Repository Secrets in GitHub
In your GitHub repo:
- Go to **Settings, Secrets and variables, Actions**
- Click **"New repository secret"** and add:
  - `DOCKER_USERNAME` → your DockerHub username
  - `DOCKER_TOKEN` → the access token you just generated

### 3. Secrets Set for This Project

 `DOCKER_USERNAME`  DockerHub username              
 `DOCKER_TOKEN`     DockerHub Personal Access Token 

## CI with GitHub Actions

### 1. What the Workflow Does
This GitHub Actions workflow:
- Triggers on pushes to the `main` branch
- Builds a Docker image using the `dockerfile` in `angular-site/`
- Logs into DockerHub using repository secrets
- Pushes the image to your DockerHub repository

### 2. Workflow Steps Explained
- **Checkout**: Pulls the code from the repo
- **Login to DockerHub**: Uses secrets to authenticate
- **Setup Docker Buildx**: Enables advanced build capabilities
- **Build & Push Image**: Builds the Docker image and pushes to DockerHub

### 3. What to Update for Your Own Repo

#### Workflow Changes
Update in `.github/workflows/main.yml`:
- `context: ./angular-site` - path to your `dockerfile`
- `tags: yourdockerhubusername/your-image-name:latest` - your actual DockerHub repo/tag

#### Repo Changes
- Make sure a `dockerfile` exists in the path you reference
- Adjust secret names only if you change them in the workflow

### Workflow File
[View the GitHub Actions Workflow Here](https://github.com/WSU-kduncan/ceg3120-cicd-T0mmyt0m/blob/main/.github/workflows/main.yml)

## Testing & Validating

### 1. Testing the Workflow
- Push a commit to the `main` branch
- Go to the **Actions** tab in GitHub
- Confirm the workflow runs successfully without errors

### 2. Verifying the Docker Image
- Log in to DockerHub and check for your new image under **Repositories**
- Test the image locally:

```
docker pull tummyz0/pua-ceg3120:latest
docker run --rm tummyz0/pua-ceg3120:latest
```

# Part 3 (Coming Soon)

### References

#### Part 1

[Creating and running an Angular application in a Docker container](https://dev.to/rodrigokamada/creating-and-running-an-angular-application-in-a-docker-container-40mk)

[Docker documentation on how to create a repository](https://docs.docker.com/docker-hub/repos/create/)

[dockerfile documentation](https://docs.docker.com/reference/dockerfile/)

#### Part 2

[Github Actions](https://docs.github.com/en/actions/security-for-github-actions/security-guides/using-secrets-in-github-actions)

[Publishing Docker images](https://docs.github.com/en/actions/use-cases-and-examples/publishing-packages/publishing-docker-images)

[Build and push Docker images](https://github.com/marketplace/actions/build-and-push-docker-images)

[GitHub Actions 101](https://github.com/pattonsgirl/CEG3120/blob/main/CourseNotes/github-actions.md)

#### Part 3 (Coming Soon)
