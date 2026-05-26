
# go-mod-upgrade (go-mod-upgrade)

upgrade outdated Go dependencies interactively.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/go-mod-upgrade:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | version of go-mod-upgrade to install | string | latest |

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


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/go-mod-upgrade/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
