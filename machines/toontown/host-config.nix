{ config, lib, pkgs, ... }:
{
  nix = {
    buildCores = 16;
    trustedUsers = [ "root" "gilligan" ];

  };

  nixpkgs = {
    overlays = [
      (import ../../overlays/neovim.nix)
      (import ../../overlays/i3.nix)
    ];
  };

  networking = {
    networkmanager.enable = true;
    hostName = "toontown";
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

  environment = {
    systemPackages = with pkgs; [
      ag
      chromium
      direnv
      entr
      fzf
      gitAndTools.gitFull
      gitAndTools.hub
      gitAndTools.tig
      jq
      neovim
      ripgrep
      shellcheck
      slack
      wget
    ];
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

  services = {
    zerotierone = {
      enable = true;
      joinNetworks = [ "83048a063215e300" ];
    };
    xserver = {
      enable = true;

      desktopManager.plasma5.enable = true;
      displayManager = {
        defaultSession = "none+i3";
        sessionCommands = ''
          gpg-connect-agent /bye
          GPG_TTY=$(tty)
          export GPG_TTY
          export XCURSOR_PATH=${pkgs.gnome3.adwaita-icon-theme}/share/icons
        '';
      };

      desktopManager.xterm.enable = true;
      windowManager.i3 = {
        enable = true;
        package = pkgs.i3-gaps;
        configFile = pkgs.i3-config-file;
      };

      xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
      autoRepeatDelay = 250;
      autoRepeatInterval = 50;
    };

  };

}
