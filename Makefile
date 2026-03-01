 .PHONY: all packages system homelab

 all: system packages

packages:
	nu ./packages/packages.nu

system:
	nu ./endeavour/endeavour.nu

homelab:
	nu ./homelab/homelab.nu
