
# CNI Plugins (cni-plugins)

Installs CNI plugins from upstream.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/cni-plugins:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | version of cni-plugins to install | string | latest |
| plugins-path | path to install the CNI plugins into | string | /usr/lib/cni |

## OS Support

Tested with:
- [ghcr.io/almalinux/almalinux](https://ghcr.io/almalinux/almalinux),
- [mcr.microsoft.com/devcontainers/base:debian](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_debian),
- [fedora](https://hub.docker.com/_/fedora),
- [mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).

## Acknowledgement

[@containernetworking/plugins](https://github.com/containernetworking/plugins)


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/cni-plugins/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
