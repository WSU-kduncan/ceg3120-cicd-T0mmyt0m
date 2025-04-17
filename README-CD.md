# CD with GitHub Actions & DockerHub

This document explains how to manage versioning with Git tags, semantic versioning, and how to automate container image builds and pushes using GitHub Actions.

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

Explanation of Workflow Steps
Checkout Code – Pulls repository code into the GitHub runner.

Log in to DockerHub – Uses GitHub secrets to authenticate DockerHub access.

Set Up Docker Buildx – Prepares Docker to build multi-platform images.

Generate Metadata – Uses docker/metadata-action to extract version info from the Git tag and create appropriate tags.

Build and Push Image – Builds the Docker image and pushes it to DockerHub with all relevant tags.

Explanation / Highlight of Values That Need Updated for Another Repository
Changes in Workflow
Update this line to match your DockerHub repository:

yaml
Copy
Edit
images: yourdockerhubusername/your-image-name
Update build context or Dockerfile path if not using ./angular-site.

Changes in Repository
Ensure you have a valid Dockerfile and the .github/workflows/docker-publish.yml workflow.

Add the following secrets in GitHub:

DOCKER_USERNAME

DOCKER_TOKEN (or password)

Link to Workflow File
Link to Workflow File

