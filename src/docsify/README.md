
# docsify

Automatically serves ./docs workspace directory via 'docsify serve' in the background.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainers-features/docsify:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| port | TCP Port serving the docsified documentation | string | 3300 |
| livereload-port | TCP port to receive live reload events from | string | 3301 |
| docs-path | workspace relative directory to serve from | string | docs |



---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
