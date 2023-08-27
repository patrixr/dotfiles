.PHONY: sync init backup

sync:
	ansible-playbook ./playbooks/setup.yml

init:
	bash ./scripts/dependencies.sh

backup:
	bash ./scripts/backup.sh
