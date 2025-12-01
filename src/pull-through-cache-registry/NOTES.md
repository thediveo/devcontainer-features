## OS Support

As this feature relies on the [Docker-in-Docker
feature](https://github.com/devcontainers/features/tree/main/src/docker-in-docker)
we only support the same Debian/Ubuntu platforms.

## Cache Volume

This feature uses a named volume `ptcr-var-lib-registry-${devcontainerId}` for
caching pulled images, where `${devcontainerId}` is a unique identifier specific
to the development container where this feature is installed into, stable across
rebuilds.

## Registry Configuration

The Distribution Registry service configuration is done by passing environment
variables to the service, as follows:

- pull-through caching is enabled by passing `REGISTRY_PROXY_REMOTEURL` (a.k.a.
  `proxy:{remoteulr:}`).
- logging is set to info level by passing `REGISTRY_LOG_LEVEL` (a.k.a.
  `log:{level:}`).
- the default `debug:` configuration is completely disabled.

## Acknowledgement

[Registry as a pull through
cache](https://distribution.github.io/distribution/recipes/mirror/), CNCF
Distribution.
