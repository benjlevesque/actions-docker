# actions-docker-gcr

GitHub Actions for common Docker workflows (Forked from https://github.com/urcomputeringpal/actions-docker)

## Usage

### Google Container Registry Setup

- If you haven't already, [create a Google Cloud Project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project) named after your GitHub username and follow the [Container Registry Quickstart](https://cloud.google.com/container-registry/docs/quickstart#before-you-begin).
- [Create a Service Account](https://cloud.google.com/iam/docs/creating-managing-service-accounts#creating_a_service_account) named after your GitHub repository.
- [Add the _Cloud Build Service Account_](https://cloud.google.com/iam/docs/granting-roles-to-service-accounts#granting_access_to_a_service_account_for_a_resource) role to this Service Account.
- [Generate a key for this Service Account](https://cloud.google.com/iam/docs/creating-managing-service-account-keys#creating_service_account_keys). Download a JSON key when prompted.
- Create a Secret on your repository named `GCLOUD_SERVICE_ACCOUNT_KEY` (Settings > Secrets) with the contents of:

```shell
# Linux
cat path-to/key.json | base64 -w 0

# MacOS
cat path-to/key.json | base64 -b 0
```

- That's it! The GitHub Actions in this repository read this Secret and provide the correct values to the Docker daemon by default if present. If a Secret isn't present, `build` _may_ succeed but `push` will return an error!

### Build and push images for each commit

Add the following to `.github/workflows/docker.yaml`:

```yaml
name: Docker

on: [push]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v1

      - name: Docker Build
        uses: benjlevesque/actions-docker-gcr/build@v1.1

      - name: Docker Push
        uses: benjlevesque/actions-docker-gcr/push@v1.1
        with:
          gcloud_key: ${{ secrets.GCLOUD_SERVICE_ACCOUNT_KEY }}
```

### Specify a different Registry, Project & image name

```yaml
    [...]
    steps:
      - uses: actions/checkout@v1

      - name: Docker Build
        uses: benjlevesque/actions-docker-gcr/build@v1.1
        with:
          image: my-project/my-image
          registry: eu.gcr.io

      - name: Docker Push
        uses: benjlevesque/actions-docker-gcr/push@v1.1
        with:
          image: my-project/my-image
          registry: eu.gcr.io
          gcloud_key: ${{ secrets.GCLOUD_SERVICE_ACCOUNT_KEY }}
```

## Parameters

### Build

| parameter  | description                       | required | default              |
| ---------  | --------------------------------- | -------- | -------------------- |
| registry   | The registry to upload to.        | false    | gcr.io               |
| image      | The name of image to build.       | false    | `$GITHUB_REPOSITORY` |
| tag        | The tag of the image.             | false    | `$GITHUB_SHA`        |
| latest     | If true, will also add latest tag | true     | `true`               |
| args       | Additional args for docker        | false    |                      |
| dockerfile | The Dockerfile to use             | false    | Dockerfile           |

### Push

| parameter  | description                                                                      | required | default              |
| ---------- | -------------------------------------------------------------------------------- | -------- | -------------------- |
| registry   | The registry to upload to.                                                       | false    | gcr.io               |
| image      | The name of image to build.                                                      | false    | `$GITHUB_REPOSITORY` |
| tag        | The tag of the image.                                                            | false    | `$GITHUB_SHA`        |
| latest     | If true, will also add latest tag                                                | true     | `true`               |
| gcloud_key | A GCloud service account json key, base64 encoded. Should be stored in a secret! | true     |
