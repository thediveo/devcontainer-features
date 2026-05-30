## WHY?!

If you are running hard into OCI registry pull throttling then this devcontainer
feature very much is right for you: it spins up a pull-through OCI registry
inside your devcontainer and additionally reconfigures the Docker demon inside
the devcontainer to use this devcontainer-local registry as its pull-through
proxy.

In the best tradition of
[dogfooding](https://en.wikipedia.org/wiki/Eating_your_own_dog_food) we use this
feature to develop our features.


## Feature Dependency

This feature has only a soft dependecy on
`ghcr.io/devcontainers/features/docker-in-docker` so that you have full control
over from where and how you bring in Docker-in-Docker.

For example:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/docker-in-docker:3": {
            "moby": false
        },
    }
}
```

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
