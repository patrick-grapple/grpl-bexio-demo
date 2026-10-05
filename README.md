# Grapple Bexio demo

A Bexio integration demo built with Grapple external operations and generated UI modules for Contacts and Invoices.

## Project structure

```
grases/gras/grapi/   – backend injections and external operations config
grases/gras/gruim/   – extension point for optional custom gruim modules
src/                 – frontend configuring and consuming the generated Contact and Invoice modules
chart/               – Helm chart and ApplicationSet values
```

## Bexio token

The backend reads the token from the `BEXIO_TOKEN` environment variable. Never expose it through a `SVELTE_APP_*` variable or commit it to Git.

For a new DevSpace environment, create the git-ignored `chart/values-secret.yaml` file before running `devspace dev`:

```yaml
secrets:
  bexioToken: "your-bexio-token"
```

The Helm chart creates a `bexio-config` Kubernetes Secret containing `BEXIO_TOKEN`.

To add or replace the token later in an existing namespace, apply the Secret directly:

```sh
kubectl --namespace <namespace> create secret generic bexio-config \
  --from-literal=BEXIO_TOKEN='your-bexio-token' \
  --dry-run=client -o yaml | kubectl apply -f -
```

Restart the Grapi pod so that it receives the updated environment variable:

```sh
kubectl --namespace <namespace> delete pod \
  -l app.kubernetes.io/name=grapi,grpl.io/resourceName=bexio-demo-gras-grapi
```

For Docker Compose, copy the example environment file and set the token there:

```sh
cp .env.example .env
# Edit .env:
BEXIO_TOKEN=your-bexio-token
```

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
