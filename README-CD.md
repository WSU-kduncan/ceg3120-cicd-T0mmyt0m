# CD with GitHub Actions & DockerHub

This document explains how to manage versioning with Git tags, semantic versioning, and how to automate container image builds and pushes using GitHub Actions.

Continuous Deployment Project Overview

    What is the goal of this project
    What tools are used in this project and what are their roles
    Diagram of project
    [If applicable] What is not working in this project
## Project goals

The goal of this project is to automate the deployment of a Dockerized Angular application Image to an AWS EC2 instance using a CD pipeline.
It ensures that whenever a new Docker image is pushed to DockerHub (via GitHub Actions), a webhook listener on the EC2 instance automatically:

 - Pulls the latest image

 - Stops and removes the old container

 - Runs the new container

## Tools and Their Roles

### AWS EC2:
 - Hosts the application server (runs Docker, webhook listener).

### Docker:
 - Packages the Angular app into a container image; runs containers on EC2.

### DockerHub:
 - Stores and distributes the Docker images; triggers webhooks when new images are pushed.

### GitHub:
 - Source code repository; optionally uses GitHub Actions to build and push images to DockerHub.

### Webhook (adnanh's webhook):
 - Listens for incoming HTTP payloads from DockerHub and triggers the bash deployment script.

### Systemd (webhook.service):
 - Ensures the webhook listener auto-starts and stays running on EC2.

### Script (deploy.sh):
 - Handles pulling the new Docker image, stopping/removing the old container, and starting the updated one automatically.



 
# Part 1

## Generating Tags

### How to See Tags in a Git Repository

```
git tag
```

How to Generate a Tag in a Git Repository using semantic versioning format:

```
git tag -a v0.1.0 -m "Initial release"
```

How to Push a Tag to GitHub

```
git push origin v0.1.0
```

# Semantic Versioning Container Images with GitHub Actions
## Summary of What the Workflow Does
### The GitHub Actions workflow:

Triggers only when a Git tag is pushed (example, v0.1.0)

Builds a Docker image using your repository's `dockerfile`

Pushes that image to DockerHub with the following tags:

- latest

- major = `0`

- major.minor = `0.1`

- major.minor.patch = `0.1.0`


## Explanation of Workflow Steps

- Checkout Code – Pulls repository code into the GitHub.

- Log in to DockerHub – Uses GitHub secrets to authenticate to DockerHub.

- Set Up Docker Buildx – Prepares Docker to build multi-platform images.

- Generate Metadata – Uses docker/metadata-action to extract version info from the Git tag and create appropriate tags.

- Build and Push Image – Builds the Docker image and pushes it to DockerHub with all relevant tags.

## Explanation / Highlight of Values That Need Updated for Another Repository

### Changes in Workflow

- Update this line to match your DockerHub repository:

```
images: yourdockerhubusername/your-image-name
```

- Update build context or Dockerfile path if not using ./angular-site.

### Changes in Repository

Make sure you have a valid `dockerfile` and the `.github/workflows/main.yml` workflow.

### Add the following secrets in GitHub:
```
DOCKER_USERNAME
```
```
DOCKER_TOKEN 
```

### Link to Workflow File
[main.yml](https://github.com/WSU-kduncan/ceg3120-cicd-T0mmyt0m/blob/main/.github/workflows/main.yml)

Testing & Validating

    How to test that your workflow did its tasking
    How to verify that the image in DockerHub works when a container is run using the image
## Testing & Validating

### Ways to test if the workflow is working

- Log in to DockerHub.
- Click on your repository.
- Under `General` tab you can see `Tags` section, which list all the versions including the latest version of the image as well as time it was published.
- Alternatively you can check `Actions` tab on github.

### Verifying working image

- Pull Image
```
docker pull tummyz0/pua-ceg3120:0.1.0
```

- Run Image 
```
docker run -p 4200:4200 tummyz0/pua-ceg3120:0.1.0
```

- Visit `http://localhost:4200` in your browser to verify it is working as expected.

# Part 2

# Automated Container Deployment using DockerHub + Webhook on AWS EC2

## EC2 Instance Details

- AMI Information: Ubuntu Server 24.04 LTS (64-bit)
- AMI ID: ami-084568db4383264d4
- Instance Type: t2.medium
- Volume Size: 30 GB
- Security Group Configuration:
  - Port 22 (SSH) - for remote access
  - Inbound & Outbound Port 9000 (Webhook Listener)
  - Inbound & Outboung Port 4200 (Angular app access)
- Justification:
  - SSH for admin access
  - 9000 for webhook payloads
  - 4200 for serving app externally

## Docker Setup on EC2 Instance

### Install Docker on AWS EC2

```
sudo apt update
sudo apt install docker.io -y
sudo systemctl enable docker
sudo systemctl start docker
```

### Add current user to docker group (to avoid sudo)

```
sudo usermod -aG docker $USER

```
### Confirm Docker is working:

```
docker --version
docker run hello-world
```

## Testing on EC2 Instance

### Pull image from DockerHub

```
docker pull yourdockerhub/image-name:tag
```

### Run container

### Dev mode (interactive)
```
docker run -it -p 4200:4200 yourdockerhub/image-name:tag
```

### Prod mode (detached)

```
docker run -d -p 4200:4200 yourdockerhub/image-name:tag
```

## Validate app/web is served in AWS:
 - Inside container CLI: `curl localhost:4200`

 - From host: curl localhost:4200

 - From browser: http://<your-ec2-ip>:4200

## Manual refresh steps:

```
docker stop <container>
docker rm <container>
docker pull yourdockerhub/image-name:tag
docker run -d -p 4200:4200 yourdockerhub/image-name:tag
```

## Scripting Container Application Refresh

Bash script: `deploy.sh`

### This script

 - Stops & removes old container

 - Pulls latest image

 - Runs a new container

## Test it manually

```
bash /var/scripts/deploy.sh
```

[deploy.sh](https://github.com/WSU-kduncan/ceg3120-cicd-T0mmyt0m/blob/main/deployment/deploy.sh)

## Configuring Webhook Listener on EC2

### Install webhook:

```
sudo apt install webhook -y
```

### Verify installation:

```
which webhook
```

### Webhook definition file:
 
 - Contains hook ID, command path, and security via token

 - Validates trigger based on `token` in URL

### Confirm definition loaded:

```
journalctl -u webhook -f
```

### Look for:

`serving hooks on` with port 9000

Docker confirmation:

```
docker ps
```

## Configuring Payload Sender
 
### Selected Sender: DockerHub
 
 - Automatically triggers webhook on new image push

### Trigger setup:
 
 - In DockerHub,Repo, Webhooks

```
http://<ec2-ip>:9000/hooks/redeploy-webhook?token=<yourtoken>
```

### Confirm successful trigger:
 
 - `journalctl -u webhook -f` shows payload received, can be seen on CLI
 
 - Container auto-restarts with updated image

## Configure Webhook Service on EC2

### webhook.service Summary
 - Starts webhook on boot
 - Loads hooks.json automatically
 - Runs under ubuntu user with docker group permissions

## Enable & start services

```
sudo cp webhook.service /etc/systemd/system/
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable webhook
sudo systemctl start webhook
```

## Validate

```
sudo systemctl status webhook
```

## Logs

```
journalctl -u webhook -f
```

# Part 3 

## Project Description & Diagram


[hooks.json](https://github.com/WSU-kduncan/ceg3120-cicd-T0mmyt0m/blob/main/deployment/webhook/hooks.json)

## References

### Part 1

 - [Manage tags and labels with GitHub Actions](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)

 - [Docker Metadata action](https://github.com/marketplace/actions/docker-metadata-action)

### Part 2

 - [Build your first CI/CD pipeline using Docker, Github Actions, and Webhooks while creating your own web curriculum](https://blog.devgenius.io/build-your-first-ci-cd-pipeline-using-docker-github-actions-and-webhooks-while-creating-your-own-da783110e151)

 - [How to create a systemd service in Linux](https://linuxhandbook.com/create-systemd-services/)

### Part 3 - Coming Soon!!!
