all: build

build:
	NIXOS_CONFIG=$$PWD/configuration.nix nixos-rebuild build

switch:
	sudo NIXOS_CONFIG=$$PWD/configuration.nix nixos-rebuild switch
