## Feature Dependency

This feature has a soft dependency on `ghcr.io/devcontainers/features/node` –
depending on you base image you already have a suitable node, otherwise you
might want to also reference the above node feature.

For example:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/node:2": {}, // unless base image has node
        "ghcr.io/thediveo/devcontainer-features/docsify:1": {}
    }
}
```

## Docs Directory

If the directory configured in the `docs-path` option does not exist, it is
automatically created when the devcontainer starts.

If the directory configured in the `docs-path` does not contain any
`index.html`, both a starter `index.html` as well as `README.md` will be
created.

## OS Support

Tested with:
- [ghcr.io/almalinux/almalinux](https://ghcr.io/almalinux/almalinux),
- [mcr.microsoft.com/devcontainers/base:debian](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_debian),
- [fedora](https://hub.docker.com/_/fedora),
- [mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).
