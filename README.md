# Dotfiles

This repository contains configuration files and scripts to set up a macOS development environment.

It automates the installation and configuration of various tools and packages, including:
- Homebrew packages
- Node setup via NVM
- ZSH
- Doom Emacs

It uses a set of **Ansible playbook** under the hood to do all of that

![](./assets/Screengrab.png)

## Getting Started

To set up your macOS development environment, follow these steps:

1. Clone the repository: `git clone https://github.com/patrixr/dotfiles.git`
2. Go into the `dotfiles` directory: `cd dotfiles`
3. Run the `make init` command to install dependencies required by the playbooks
4. Run the `make sync` script to run all Ansible playbooks

You can also run `make apply` whenever you want to update the installed packages to the latest version or apply changes to the setup.
