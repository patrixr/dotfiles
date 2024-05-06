.PHONY: sync init backup homebrew development configs services

sync: homebrew zsh development configs services

homebrew:
	ansible-playbook -v ./playbooks/homebrew.yml

development:
	ansible-playbook -v ./playbooks/development.yml

configs:
	ansible-playbook -v ./playbooks/configs.yml;
	ansible-playbook -v ./playbooks/emacs.yml;

dependencies:
	bash ./scripts/dependencies.sh

backup:
	bash ./scripts/backup.sh
