
# containerd control CLI (nerdctl)

Installs nerdctl from upstream.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/nerdctl:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | version of cni-plugins to install | string | latest |
| containerd-api | path to containerd API endpoint | string | unix:///run/containerd/containerd.sock |

## Combining with `docker-in-docker` Feature

Please note that the `docker-in-docker` feature is only available for
Debian/Docker-based base images.

In order to use nerdctl with the `containerd` included in the
[`docker-in-docker`](https://github.com/devcontainers/features/tree/main/src/docker-in-docker)
feature, you need to explicitly configure the non-standard API endpoint URL for
`containerd` as follows:

```json
    "features": {
        "ghcr.io/devcontainers/features/docker-in-docker:2": {
            "dockerDashComposeVersion": "none",
            "installDockerBuildx": false
        },
        "ghcr.io/devcontainers/features/nerdctl:0": {
            "containerd-api": "unix:///run/docker/containerd/containerd.sock"
        }
    }
```

## OS Support

Tested with:
- [ghcr.io/almalinux/almalinux](https://ghcr.io/almalinux/almalinux),
- [mcr.microsoft.com/devcontainers/base:debian](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_debian),
- [fedora](https://hub.docker.com/_/fedora),
- [mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).

## Acknowledgement

[@containerd/nerdctl](https://github.com/containerd/nerdctl)


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/nerdctl/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
