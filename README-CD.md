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

## References

[Manage tags and labels with GitHub Actions](https://docs.docker.com/build/ci/github-actions/manage-tags-labels/)

[Docker Metadata action](https://github.com/marketplace/actions/docker-metadata-action)
