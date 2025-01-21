
# install and switch between multiple Docker CE versions (wal-wahl)

Install and switch between multiple Docker CE versions, activating one version at a time, and switching on-the-fly.

## Example Usage

```json
"features": {
    "ghcr.io/thediveo/devcontainer-features/wal-wahl:0": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| versions | list of Docker Engine versions, separated by comma | string | 26,27 |
| azureDnsAutoDetection | Allow automatically setting the dockerd DNS server when the installation script detects it is running in Azure | boolean | false |
| dockerDefaultAddressPool | Define default address pools for Docker networks. e.g. base=192.168.0.0/16,size=24 | string | - |
| disableIp6tables | Disable ip6tables (this option is only applicable for Docker versions 27 and greater) | boolean | false |

## Customizations

### VS Code Extensions

- `ms-azuretools.vscode-docker`

## Trivia

"Wal-Wahl" is a German pun with homophons, meaning picking/voting for a whale.

## Usage

Make sure to specify the Docker versions (separated by commas) you want to have
installed into your devcontainer when requesting the `wal-wahl` feature:

```json
{
  "features": {
    "ghcr.io/thediveo/devcontainer-features/wal-wahl:0": {
      "versions": "20,27"
    }
}
}
```

Please note that the available Docker CE versions vary by distribution (Debian
versus Ubuntu) and release (buster/bullseye/bookworm versus 20.04/22.04/24.04).

This feature installs a command `/usr/local/bin/whale-select` to list the
installed Docker versions, as well as to activate _one of them at a time_ or
deactivate it without activating another one. It is _not possible_ to activate
_multiple_ Docker versions _simultaneously_.

### List Installed Versions

`whale-select list` lists the Docker versions installed into this devcontainer.
For instance:

```
$ whale-select list
20.10.24
26.1.4
$ █
```

### Activating a Specific Version

`whale-select VERSIONPREFIX` activates the Docker version starting with the
specified VERSIONPREFIX; it will error if VERSIONPREFIX matches multiple
installed Docker versions. If another Docker version is currently activated, it
will be deactivated first.

```
$ sudo whale-select 26
activating 26.1.4...
$ █
```

```
$ sudo whale-select 2
error: ambiguous version "2" specified.
available versions:
    20.10.24
    26.1.4
$ █
```

### Deactivating

`whale-select none` deselects the currently active Docker version (if any).
It is no error when there is no currently activated Docker version.

```
$ sudo whale-select none
deactivating current Docker/Moby...
$ █
```

## Limitations

- currently supports only installing Docker CE
- no control over the compose plugin version (this is a limitation inherited
  from Microsoft's DinD feature).

## OS Support

This Feature should work on recent versions of Debian/Ubuntu-based distributions
with the `apt` package manager installed.

`bash` is required to execute the `install.sh` and `dind/install.sh` scripts.

## Superfluous Notes

- best viewed on a VT100 terminal with amber CRT.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/thediveo/devcontainer-features/blob/main/src/wal-wahl/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
