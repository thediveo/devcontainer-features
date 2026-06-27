
# docsify server (docsify)

Automatically serves ./docs (or another) workspace directory via 'browser-sync' in the background.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/docsify:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| port | TCP port serving the docsified documentation | string | 3300 |
| docs-path | workspace relative directory to serve from | string | docs |
| reload-delay | time in milliseconds to delay the reload event following file changes | string | 2000 |
| reload-debounce | time in milliseconds to restrict the frequency in which browser:reload events can be emitted to connected clients | string | 5000 |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/docsify/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
