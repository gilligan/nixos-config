all: build

build:
	NIXOS_CONFIG=$$PWD/configuration.nix nixos-rebuild build

switch:
	NIXOS_CONFIG=$$PWD/configuration.nix nixos-rebuild switch
