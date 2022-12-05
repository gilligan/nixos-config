{ config, lib, pkgs, ... }:
let
  nixpkgs = import ../../nix;
  configDir = toString ./.;
  sources = import ../../npins;
  _nixpkgs = sources.nixpkgs;
in
{
  imports = [
    ./hardware.nix

    ../../profiles/generic.nix
    ../../profiles/plasma5-with-i3.nix
    ../../profiles/terminal.nix
    ../../profiles/pulseaudio.nix
    ../../profiles/nix-direnv.nix
    #../../profiles/elements-usb-disk.nix
    #../../profiles/assetupnp.nix
  ];

  system.nixos.versionSuffix = _nixpkgs.revision;
  system.nixos.version = _nixpkgs.branch;

  environment.etc."nixos-configuration".source = pkgs.nix-gitignore.gitignoreSource [ ] ./.;
  environment.etc."nixos-sources".source = pkgs.symlinkJoin {
    name = "sources";
    paths = lib.attrValues (
      lib.mapAttrs
        (name: path:
          pkgs.runCommandNoCC "${name}-src" { inherit name path; } "mkdir $out; ln -s $path $out/$name"
        )
        (lib.filterAttrs (_: v: !lib.isFunction v) sources)
    );
  };
  environment.systemPackages = [
    (pkgs.writeShellScriptBin "rebuild" ''
      PATH="${config.nix.package}/bin:$PATH"
      set -exu
      set -o pipefail
      REBUILD=$(nix-build --no-out-link ${configDir} -A rebuild)
      exec "$REBUILD" "$@"
    '')
  ];

  nix = {
    settings = {
      trusted-users = [ "root" "gilligan" ];
      cores = 16;
    };
    nixPath = lib.mkForce [ "nixpkgs=${_nixpkgs}" ];
    extraOptions = ''
      allowed-uris = https://github.com
    '';
  };


  nixpkgs = {
    pkgs = nixpkgs;
    config = {
      allowUnfree = true;
      allowAliases = true;
    };
    overlays = [
      (import ../../overlays/i3.nix)
      #(import ../../overlays/assetupnp.nix)
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

  programs.steam.enable = true;

  services = {

    # Nintendo Gamecube Controller
    udev.extraRules = ''
      SUBSYSTEM=="usb", ENV{DEVTYPE}=="usb_device", ATTRS{idVendor}=="057e", ATTRS{idProduct}=="0337", MODE="0666"
    '';

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
