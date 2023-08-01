# pocketbase-fly

This repo can be used to spin up a slim VM running [Pocketbase](https://pocketbase.io) on [Fly.io](https://fly.io).
The Docker image is based on Google's distroless containers, which comes with security benefits and usability drawbacks, see `Dockerfile`.
This project has a GitHub Action configured to continuously deploy the app.

## Fly.io specifics

### Launch this app on Fly.io

- sign up on [Fly.io](https://fly.io), e.g. via GitHub
- install `flyctl` on your machine: `brew install flyctl`
- log in via `fly auth login`
- launch via  `fly launch`, use the checked in `fly.toml`
- deploy changes via `fly deploy`, or use the GitHub Action explained in the next step

### CD with GitHub Action

- generate a deploy token via `fly tokens create deploy -x 999999h`
- go to your repository on GitHub and select `Settings`
- under `Secrets and variables`, select `Actions`, and then create a new repository secret called `FLY_API_TOKEN` with the value of this freshly generated token
- a push to `main` or merge a pull request to `main` will trigger a deploy action
