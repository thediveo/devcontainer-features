
# OCI registry pull-through cache to mirror rate-limited upstream registries, such as Docker Hub (pull-through-cache-registry)

Deploys a devcontainer-local CNCF Distribution Registry configured as a pull-through cache for the local docker-in-docker

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/pull-through-cache-registry:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| proxy-remote-url | URL of the upstream OCI registry. | string | https://registry-1.docker.io |
| port | port to bind the CNCF Distribution Registry service to. | string | 5000 |
| ttl | expire proxy cache storage after this duration, 168h corresponds with 7 days by default, set to 0 to disable any expiration. Valid duration suffixes are s, m, h, without suffix nanoseconds are assumed. | string | 168h |
| registry-name | the Docker container name to give the CNCF Distribution Registry. | string | registry-cache |
| wait | maximum wait time in seconds for Docker to become available when starting the CNCF Distribution Registry service. | string | 30 |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/pull-through-cache-registry/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
