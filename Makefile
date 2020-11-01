all: build

build: ./host-config.nix ./host-hardware.nix
	NIXOS_CONFIG=$$PWD/configuration.nix nixos-rebuild build

switch:
	NIXOS_CONFIG=$$PWD/configuration.nix nixos-rebuild switch
