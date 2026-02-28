 .PHONY: default

 all: packages system

packages:
	nu ./packages.nu

system:
	nu ./endeavour.nu
