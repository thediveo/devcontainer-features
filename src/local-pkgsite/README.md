
# Local Go Pkgsite (local-pkgsite)

A local Go pkgsite serving the module documentation, with automatic browser refresh.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/local-pkgsite:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| port | TCP port serving packages documentation | string | 6060 |
| reload-delay | time in milliseconds to delay the reload event following file changes | string | 2000 |
| reload-debounce | time in milliseconds to restrict the frequency in which browser:reload events can be emitted to connected clients | string | 5000 |

## Feature Dependency

This feature has a soft dependecy on `ghcr.io/devcontainers/features/go` so that
you have full control over from where and how you bring in the go toolchain.

Similar, it has a soft dependency on `ghcr.io/devcontainers/features/node` –
depending on you base image you already have a suitable node, otherwise you
might want to also reference the above node feature.

For example:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/go:1": {},
        "ghcr.io/devcontainers/features/node:2": {}, // unless base image has node
        "ghcr.io/thediveo/devcontainer-features/local-pkgsite:1": {}
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

[@mdaverde](https://github.com/mdaverde) for his blog post [Build your Golang
package docs locally](https://mdaverde.com/posts/golang-local-docs/) that forms
the basis for this devcontainer feature.

## Operation

The port configured with the `port` option is served by
[`browser-sync`](https://browsersync.io/docs/command-line), and `browser-sync`
in turn proxies `pkgsite`. `pkgsite` is started with a random port from the
[ephemeral port
range](https://en.wikipedia.org/wiki/Ephemeral_port#cite_note-5), this random
port is determined once when the devcontainer starts and then kept constant.
[`nodemon`](https://github.com/remy/nodemon#nodemon) monitors your Go sources
for changes and then triggers a browser refresh and `pkgsite` restart.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/local-pkgsite/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
