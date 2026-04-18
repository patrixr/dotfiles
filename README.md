# Dotfiles

My personal configuration layer for [Hyperion CE](https://github.com/patrixr/hyperion), built around [Nushell](https://www.nushell.sh/).

## What is this?

This repository contains my **personal** configurations and preferences that layer on top of [Hyperion CE](https://github.com/patrixr/hyperion) - an EndeavourOS Community Edition featuring Niri compositor and Noctalia shell.

**Hyperion provides:**
- Base OS configuration (Niri, Noctalia, Ghostty, SDDM)
- System-level packages
- Generic defaults for any Hyperion user

**This dotfiles repo provides:**
- Personal applications (Zed, Steam, ProtonVPN, etc.)
- Development tools (Volta, Docker, AWS CLI, etc.)
- Personal editor configs (Emacs, Zed)
- Custom keybinds and Noctalia customizations
- Personal wallpapers

## The Glue Library

`glue` is a Nushell utility library shared between Hyperion and this repo. It provides:

- Cross-platform helpers (Linux/macOS detection and execution)
- Package installation wrappers for system package managers
- Configuration injection utilities
- Nushell vendor package management

## Getting Started

Install or update Hyperion base system:

```bash
make hyperion
```

Apply personal configurations:

```bash
make configs
# or just: make
```

Do everything:

```bash
make all
```

## Dependencies

- [Nushell](https://www.nushell.sh/)
- [Hyperion CE](https://github.com/patrixr/hyperion) (installed via `make hyperion`)
