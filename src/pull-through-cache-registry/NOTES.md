## OS Support

As this feature relies on the [Docker-in-Docker
feature](https://github.com/devcontainers/features/tree/main/src/docker-in-docker)
we only support the same Debian/Ubuntu platforms.

## Registry Configuration

- pull-through caching is enabled by passing `REGISTRY_PROXY_REMOTEURL` (a.k.a.
  `proxy:{remoteulr:}`).
- logging is set to info level by passing `REGISTRY_LOG_LEVEL` (a.k.a.
  `log:{level:}`).

## Acknowledgement

[Registry as a pull through
cache](https://distribution.github.io/distribution/recipes/mirror/), CNCF
Distribution.
