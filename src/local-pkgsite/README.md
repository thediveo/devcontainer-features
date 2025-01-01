
# Local Go Pkgsite (local-pkgsite)

A local Go pkgsite serving the module documentation

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/local-pkgsite:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| port | TCP port serving packages documentation | string | 6060 |
| reload-delay | time in milliseconds to delay the reload event following file changes | string | 2000 |
| reload-debounce | time in milliseconds to restrict the frequency in which browser:reload events can be emitted to connected clients | string | 5000 |

## OS Support

Tested only with
[mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).

## Acknowledgement

...to [@mdaverde](https://github.com/mdaverde) for his blog post [Build your
Golang package docs locally](https://mdaverde.com/posts/golang-local-docs/) that
forms the basis for this devcontainer feature.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/local-pkgsite/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
