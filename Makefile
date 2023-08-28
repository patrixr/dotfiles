.PHONY: sync init backup homebrew zsh node doom

sync: homebrew zsh node doom

homebrew:
	ansible-playbook -v ./playbooks/homebrew.yml

zsh:
	ansible-playbook -v ./playbooks/zsh.yml

node:
	ansible-playbook -v ./playbooks/node.yml

doom:
	ansible-playbook -v ./playbooks/doom.yml

dependencies:
	bash ./scripts/dependencies.sh

backup:
	bash ./scripts/backup.sh
