
# OCI registry pull-through cache to mirror rate-limited upstream registries, such as Docker Hub (pull-through-cache-registry)

provides a devcontainer-local CNCF Distribution Registry configured as a pull-through cache for the local docker-in-docker

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/pull-through-cache-registry:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| port | port to bind the CNCF Distribution Registry service to | string | 5000 |
| registry-name | the Docker container name to give the CNCF Distribution Registry | string | registry-cache |
| wait | maximum wait time in seconds for Docker to become available when starting the CNCF Distribution Registry service | string | 30 |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/pull-through-cache-registry/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
