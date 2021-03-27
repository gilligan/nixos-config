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
    ../../profiles/elements-usb-disk.nix
    ../../profiles/assetupnp.nix
  ];


  nix = {
    buildCores = 16;
    trustedUsers = [ "root" "gilligan" ];
    nixPath = [ "nixpkgs=${nixpkgs.path}" ];
    extraOptions = ''
      allowed-uris = https://github.com
    '';
  };

  nixpkgs = {
    pkgs = nixpkgs;
    config = {
      allowUnfree = true;
    };
    overlays = [
      (import ../../overlays/neovim.nix)
      (import ../../overlays/i3.nix)
      (import ../../overlays/assetupnp.nix)
    ];
  };

  networking = {
    hostName = "toontown";
    networkmanager.enable = true;
    firewall = {
      enable = false;
      #allowedUDPPorts = [ 1900 5353 ];
    };
  };

  hardware = {
    opengl.enable = true;
  };

  services = {

    hydra = {
      enable = false;
      hydraURL = "toontown";
      notificationSender = "hydra@toontown";
    };

  };

  sound.extraConfig = ''
    pcm.!default {
      type hw
      card 1
    }
    ctl.!default {
      type hw
      card 1
    }
  '';

  virtualisation = {
    virtualbox.host.enable = false;
    docker.enable = true;
    libvirtd.enable = true;
  };

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
