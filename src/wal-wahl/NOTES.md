## Trivia

"Wal-Wahl" is a German pun with homophons, meaning picking/voting for a whale.

## Usage

This feature installs a command `/usr/local/bin/whale-select` to list the
installed Docker versions, as well as to activate _one of them at a time_ or
deactivate it without activating another one. It is not possible to activate
multiple Docker versions simultaneously.

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
