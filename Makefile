.PHONY: sync init backup homebrew node configs services

sync: homebrew zsh node configs services

homebrew:
	ansible-playbook -v ./playbooks/homebrew.yml

node:
	ansible-playbook -v ./playbooks/node.yml

configs:
	ansible-playbook -v ./playbooks/configs.yml;
	ansible-playbook -v ./playbooks/doom.yml;

services:
	ansible-playbook -v ./playbooks/services.yml --ask-become-pass

dependencies:
	bash ./scripts/dependencies.sh

backup:
	bash ./scripts/backup.sh
