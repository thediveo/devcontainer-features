## Feature Dependency

This feature has only a soft dependecy on `ghcr.io/devcontainers/features/go` so
that you have full control over from where and how you bring in the go
toolchain.

For example:

```json
{
    "features": {
        "ghcr.io/devcontainers/features/go:1": {},
        "ghcr.io/thediveo/devcontainer-features/go-mod-upgrade:1": {}
    }
}
```

## OS Support

Tested only with
[mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).
