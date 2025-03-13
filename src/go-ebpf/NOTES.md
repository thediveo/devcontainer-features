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
