{ config, lib, pkgs, ... }:
let
  nixpkgs = import ../../nix;
in
{
  imports = [
    ./hardware.nix

    ../../profiles/generic.nix
    ../../profiles/plasma5-with-i3.nix
    ../../profiles/terminal.nix
    ../../profiles/pulseaudio.nix
    ../../profiles/nix-direnv.nix
    ../../profiles/libinput.nix
  ];

  nix = {
    buildCores = 4;
    trustedUsers = [ "root" "gilligan" ];
    nixPath = [ "nixpkgs=${nixpkgs.path}" ];
  };

  nixpkgs = {
    pkgs = nixpkgs;
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ../../overlays/i3.nix)
    ];
  };

  networking = {
    hostName = "semigroup";
    networkmanager.enable = true;
    firewall.enable = false;
  };

  hardware = {
    opengl.enable = true;
  };

  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [ "83048a063215e300" ];
    };
  };

  virtualisation = {
    virtualbox.host.enable = false;
    docker.enable = true;
    libvirtd.enable = true;
  };

  powerManagement.enable = true;
  powerManagement.powertop.enable = true;

  users.extraUsers.gilligan = {
    isNormalUser = true;
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" "docker" "libvirtd" ];
    createHome = true;
    home = "/home/gilligan";
    shell = "/run/current-system/sw/bin/zsh";
  };
  system.stateVersion = "20.03";
}
