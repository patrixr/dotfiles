.PHONY: sync init backup homebrew zsh node configs

sync: homebrew zsh node configs

homebrew:
	ansible-playbook -v ./playbooks/homebrew.yml

zsh:
	ansible-playbook -v ./playbooks/zsh.yml

node:
	ansible-playbook -v ./playbooks/node.yml

configs:
	ansible-playbook -v ./playbooks/configs.yml

dependencies:
	bash ./scripts/dependencies.sh

backup:
	bash ./scripts/backup.sh
