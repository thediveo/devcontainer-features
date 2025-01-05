
# docsify (docsify)

Automatically serves ./docs workspace directory via 'docsify serve' in the background.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/docsify:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| port | TCP port serving the docsified documentation | string | 3300 |
| livereload-port | TCP port to receive live reload events from | string | 3301 |
| docs-path | workspace relative directory to serve from | string | docs |

## OS Support

Tested only with
[mcr.microsoft.com/devcontainers/base:ubuntu](https://mcr.microsoft.com/en-us/artifact/mar/devcontainers/base/about#about:_ubuntu).

## Docs Directory

If the directory configured in the `docs-path` option does not exist, it is
automatically created when the devcontainer starts.

If the directory configured in the `docs-path` does not contain any
`index.html`, both a starter `index.html` as well as `README.md` will be
created.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/docsify/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
