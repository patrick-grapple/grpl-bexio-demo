# Grapple Bexio demo

A Bexio integration demo built with Grapple external operations and generated UI modules for Contacts and Invoices.

## Project structure

```
grases/gras/grapi/   – backend injections and external operations config
grases/gras/gruim/   – custom Svelte UI modules and gruim prepatches
src/                 – frontend consuming the generated Contact and Invoice modules
chart/               – Helm chart and ApplicationSet values
```

## Bexio token

The token is stored in the `bexio-config` Kubernetes Secret. For local development, create `chart/values-secret.yaml`:

```yaml
secrets:
  bexioToken: "your-bexio-token"
```

This file is git-ignored. The chart creates the Secret from it automatically before DevSpace deploys.

## Cluster development (DevSpace)

Requirements: Grapple cluster, `grpl` CLI, `devspace`, `helm`, `task`, `yq` v4.

```sh
kubectl create namespace <namespace>
grpl dev ns <namespace>
devspace dev
```

| Service  | URL                   |
|----------|-----------------------|
| Frontend | http://localhost:4000 |
| Gruim    | http://localhost:8080 |
| Grapi    | http://localhost:3000 |

## Local development (Docker Compose)

Requires Node 22 and pnpm 9.15.9.

```sh
pnpm install --frozen-lockfile
cp .env.example .env
# Set BEXIO_TOKEN in .env
docker compose up -d
pnpm dev
```

gruim → `http://localhost:8080`, Grapi → `http://localhost:3333`, frontend → `http://localhost:4000`.

## Useful commands

```sh
task patch-values-file    # generate base64 injections into the values file
task reset-values-file    # clear injections
task package-push         # package and push the chart
task package-push-deploy  # package, push and deploy
```

```sh
grpl gruim rebuild        # rebuild gruim
```
