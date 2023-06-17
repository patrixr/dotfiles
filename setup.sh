#!/bin/bash

function does_file_exist() {
    [ -e "$1" ]
}

function does_command_exist() {
    command -v "$1" &> /dev/null
}

function install_homebrew() {
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

function install_git() {
    echo "Installing Git..."
    brew install git
}

function install_ansible() {
    echo "Installing Ansible..."
    brew install ansible
}

function install_ansible_galaxy_homebrew() {
    echo "Installing Ansible Galaxy Homebrew package..."
    ansible-galaxy collection install community.general
}

function run_ansible_playbook() {
    echo "Running Ansible playbook: setup.yml"
    ansible-playbook setup.yml
}

# Install Homebrew if it's not installed
if ! does_command_exist brew; then
    install_homebrew
fi

# Install Git if it's not installed
if ! does_command_exist git; then
    install_git
fi

# Install Ansible if it's not installed
if ! does_command_exist ansible; then
    install_ansible
fi

# Install Ansible Galaxy Homebrew package
install_ansible_galaxy_homebrew

# Run the Ansible playbook
run_ansible_playbook

echo "Mac environment setup complete."
