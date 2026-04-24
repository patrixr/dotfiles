.PHONY: all hyperion configs homelab

configs:
	@echo "⚙️  Applying personal configs..."
	nu ./configs.nu

all: hyperion configs

hyperion:
	@echo "🚀 Installing/updating Hyperion CE..."
	curl -sL https://raw.githubusercontent.com/patrixr/hyperion/main/hyperion.sh | sudo bash

homelab:
	nu ./homelab/homelab.nu
