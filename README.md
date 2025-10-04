# TheDiveO's Dev Container Features

A collection of somewhat ~~weird~~ unique Dev Container features, currently not
found elsewhere (to the best of my knowledge). With an emphasis on Go tooling
not already covered by the VSCode Go plugin.

Where applicable, multiple different distribution base images are supported, but
unfortunately only to the limitation of different distribution support in Dev
Containers features we rely on. In case of Go tools, this unfortunately leaves
out Alpine, because [Microsoft's Go Dev Container feature does not support
Alpine](https://github.com/devcontainers/features/blob/091886b3568dad70f835cc428dad1fdf7bc6a9b3/src/go/install.sh#L32-L44).

- [bpftool](src/bpftool/README.md) – installs `bpftool` directly from upstream
  https://github.com/libbpf/bpftool binary releases, especially avoiding the
  usual pain of upstream Debian/Ubuntu kernel-specific bpftool packages.

- [cni-plugins](src/cni-plugins/README.md) – installs CNI plugins directly from
  upstream https://github.com/containernetworking/plugins binary releases.

- [docsify](src/docsify/README.md) – automatically serves ./docs workspace
  directory via `docsify serve` in the background (with the specific workspace
  location being configurable).

- [grafanactl](src/grafanactl/README.md) – installs `grafanactl` directly from
  upstream https://github.com/grafana/grafanactl binary releases.

- [gocover](src/gocover/README.md) – provides a `gocover` command to run
  conveniently unit tests and update a README.md coverage badge, supporting a
  set of presets. This even supports running coverage both as the container
  developer user as well as root, and then aggregating coverage. Additionally, a
  coverage badge is automatically maintained in the repository's `README.md`.

- [go-ebpf](src/go-ebpf/README.md) – installs clang and llvm, and on top
  Cilium's `bpf2go` to develop Go tools using eBPF.

- [go-mod-upgrade](src/go-mod-upgrade/README.md) – provides obligot's `go-mod-upgrade`
  for updating outdated Go dependencies interactively.

- [goreportcard](src/goreportcard/README.md) – provides `goreportcard-cli`that
  creates a Go report and a `README.md` badge on the code quality of a
  repository.

- [local-pkgsite](src/local-pkgsite/README.md) – a local Go pkgsite serving the
  module documentation, with automatic project reload and browser refresh. 

- [nerdctl](src/nerdctl/README.md) – installs `nerdctl` directly from upstream
  https://github.com/containerd/nerdctl binary releases.

- [pin-github-action](src/pin-github-action/README.md) – provides mheaps's
  `pin-github-action` for pinning GitHub actions to specific hashes.

- [wal-wahl](src/wal-wahl/README.md) – install multiple Docker CE versions
  inside your devcontainer, quickly switching and activating one of them at a
  time.
