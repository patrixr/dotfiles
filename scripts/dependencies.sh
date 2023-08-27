#!/bin/bash

# --------------------------------------------------
# ONE-TIME SCRIPT
#--------------------------------------------------

set -e

echo "=== Installing HomeBrew"

#/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "=== Setting up .zprofile with Homebrew information"

(echo; echo 'eval "$(/opt/homebrew/bin/brew shellenv)"') >> /Users/patrick/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

echo "=== Installing zsh and ansible with homebrew"

brew install zsh ansible

echo "=== Installing Oh My Zsh"

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "=== Restoring backed-up zsh configurations (.zshrc)"

cat ./configs/zshrc.sh >> ~/.zshrc

echo "=== Installing ansible collections needed by the playbook"

ansible-galaxy collection install community.general
