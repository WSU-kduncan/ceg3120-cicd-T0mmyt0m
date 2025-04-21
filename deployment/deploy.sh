#!/bin/bash

# --- Configuration ---
CONTAINER_NAME="pua-ceg3120"
DOCKERHUB_IMAGE="tummyz0/pua-ceg3120:latest"
DOCKER_RUN_OPTIONS="-d -p 4200:4200 --restart unless-stopped"

# --- Begin Script ---

# Step 1: Stop and remove existing container
docker stop $CONTAINER_NAME || true
docker rm $CONTAINER_NAME || true

# Step 2: Pull latest image
docker pull $DOCKERHUB_IMAGE

# Step 3: Run new container
docker run $DOCKER_RUN_OPTIONS --name $CONTAINER_NAME $DOCKERHUB_IMAGE
