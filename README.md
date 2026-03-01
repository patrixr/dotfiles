# Dotfiles

My personal configuration for [EndeavourOS](https://endeavouros.com/), built around [Nushell](https://www.nushell.sh/) as the base shell.

## Desktop Environment

Uses [Niri](https://github.com/YaLTeR/niri), a scrollable-tiling Wayland compositor, with:

- Ghostty terminal emulator
- Fuzzel application launcher
- Starship prompt

## The Glue Library

`glue` is a Nushell utility library that provides helper functions for system configuration and package management. It includes:

- Cross-platform helpers (Linux/macOS detection and execution)
- Package installation wrappers for system package managers
- Configuration injection utilities
- Nushell vendor package management

The library is designed to make dotfile management and system setup declarative and reproducible.

## Getting Started

Install system packages and desktop environment:

```bash
make system
```

Install additional packages:

```bash
make packages
```

## Dependencies

- [Nushell](https://www.nushell.sh/)
