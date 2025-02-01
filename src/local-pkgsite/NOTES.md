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
