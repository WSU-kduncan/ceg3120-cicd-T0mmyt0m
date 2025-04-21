#!/bin/bash

# --- Configuration ---
# STOP: Don't run this script without replacing these placeholder values!

# Name for your container
CONTAINER_NAME="tummyz0/pua-ceg3120"

# Your Docker Hub username
DOCKERHUB_USERNAME="tummyz0"

# The name of your repository on Docker Hub
DOCKERHUB_REPO="tummyz0/pua-ceg3120"

# The tag you want to pull
IMAGE_TAG="latest"

# Docker run options (customize as needed!)
# Example: Run detached (-d), map host port 8080 to container port 80 (-p 8080:80),
# set restart policy (--restart always), pass environment variables (-e VAR=value)
# Make sure to include '-d' if you want it to run in the background.
DOCKER_RUN_OPTIONS="-d -p 4200:4200 --restart unless-stopped"

# --- Script Logic ---

# Construct the full image name
FULL_IMAGE_NAME="$DOCKERHUB_USERNAME/$DOCKERHUB_REPO:$IMAGE_TAG"

echo "--- Starting deployment process for $CONTAINER_NAME ---"

# Exit script immediately if any command fails
set -e

# Step 1: Stop the currently running container (if it exists)
# We use '|| true' so the script doesn't exit if the container doesn't exist yet
echo "Attempting to stop container: $CONTAINER_NAME..."
docker stop $CONTAINER_NAME || true

# Step 2: Remove the stopped container (if it exists)
echo "Attempting to remove container: $CONTAINER_NAME..."
docker rm $CONTAINER_NAME || true

# Step 3: Pull the latest tagged image from Docker Hub
echo "Pulling image: $FULL_IMAGE_NAME..."
# If your Docker Hub repository is PRIVATE, you might need to run 'docker login' before this script
# or configure Docker credential helpers on your EC2 instance.
docker pull $FULL_IMAGE_NAME

# Step 4: Run a new container with the pulled image
echo "Running new container: $CONTAINER_NAME from image $FULL_IMAGE_NAME..."
docker run $DOCKER_RUN_OPTIONS --name $CONTAINER_NAME $FULL_IMAGE_NAME

echo "--- Deployment complete for $CONTAINER_NAME ---"

exit 0
