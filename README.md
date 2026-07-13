# ODI — OpenShell Developer Image

Cloud development environment for [OpenShell](https://github.com/NVIDIA/OpenShell)
and [OGO](https://github.com/aknochow/ogo) operator development.

## What's included

| Tool | Version | Purpose |
|------|---------|---------|
| Go | 1.24.5 | Operator development |
| OpenShell CLI | latest | Sandbox management |
| golangci-lint | v2.1.0 | Go linting |
| oc / kubectl | (from UDI) | Cluster management |
| gh | 2.74.1 | GitHub CLI |
| k9s | v0.50.9 | Kubernetes TUI |
| jq, make | (system) | Build tooling |

Base image: `quay.io/devfile/universal-developer-image:ubi10-latest`

## Usage

### With DevSpaces / Eclipse Che

Open any repo that includes a devfile referencing this image, or start
a workspace directly:

```
https://devspaces.apps.your-cluster.example.com/#https://github.com/aknochow/odi
```

### With devcontainers

```json
{
  "image": "quay.io/aknochow/odi:latest"
}
```

### Standalone

```bash
podman run -it quay.io/aknochow/odi:latest
```

## Build

```bash
podman build -t quay.io/aknochow/odi:latest .
podman push quay.io/aknochow/odi:latest
```

## License

Apache License 2.0
