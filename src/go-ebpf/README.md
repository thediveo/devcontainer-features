
# Go ebpf development (go-ebpf)

Installs clang and llvm, and on top Cilium's bpf2go.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/go-ebpf:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| bfp2go-version | version of bpf2go to install | string | latest |

## Customizations

### VS Code Extensions

- `ms-vscode.cpptools-extension-pack`

## PID Namespace

Depending on what your eBPF is doing inside the devcontainer (or inside a
container inside your devcontainer), consider deploying your devcontainer in the
root PID namespace, as follows:

```json
"runArgs": [
    "--pid=host"
]
```

Otherwise, your eBPF programs see root PID namespace PIDs and TIDs, but your
user space code sees child PID namespace PIDs and TIDs, ensuring an endless
supply of surprise.

## OS Support

Tested with:
- [ghcr.io/almalinux/almalinux](https://ghcr.io/almalinux/almalinux),
- [mcr.microsoft.com/devcontainers/base:debian](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_debian),
- [fedora](https://hub.docker.com/_/fedora),
- [mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).

## Acknowledgement

[@cilium](https://github.com/cilium) for their incredibly useful
[ebpf](https://github.com/cilium/ebpf) Go module.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/go-ebpf/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
