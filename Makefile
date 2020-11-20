all: build

HOST=$(shell hostname)

build:
	NIXOS_CONFIG=$$PWD/machines/${HOST}/configuration.nix nixos-rebuild build

switch:
	NIXOS_CONFIG=$$PWD/machines/${HOST}/configuration.nix nixos-rebuild switch

update-nixpkgs:
	niv update nixpkgs
	direnv reload
