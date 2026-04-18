.PHONY: all hyperion configs homelab

all: hyperion configs

hyperion:
	@echo "🚀 Installing/updating Hyperion CE..."
	curl -sL https://raw.githubusercontent.com/patrixr/hyperion/main/hyperion.sh | sudo bash

configs:
	@echo "⚙️  Applying personal configs..."
	nu ./configs.nu

homelab:
	nu ./homelab/homelab.nu
