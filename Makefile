 .PHONY: default

 all: system packages

packages:
	nu ./packages.nu

system:
	nu ./endeavour.nu
