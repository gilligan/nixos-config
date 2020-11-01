{ config, lib, pkgs, ... }:
let
  nixpkgs = import ./nix;
in
{
  imports = [
    ./host-config.nix
    ./host-hardware.nix
  ];

  boot = {
    loader.systemd-boot.enable = true;
    initrd.kernelModules = [ "fbcon" ];
    cleanTmpDir = true;
  };

  nix = {
    nixPath = [ "nixpkgs=${nixpkgs.path}" ];
    useSandbox = true;
    gc = {
      automatic = true;
    };
    extraOptions = ''
      auto-optimise-store = true
      keep-outputs = true
      keep-derivations = true
    '';
  };

  nixpkgs = {
    pkgs = nixpkgs;
    config = {
      allowUnfree = true;
    };
  };

  time.timeZone = "Europe/Berlin";

  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "ter-i32b";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  programs = {
    command-not-found.enable = true;
    tmux = {
      enable = true;
      terminal = "screen-256color";
      extraConfig = builtins.readFile ./assets/tmux.conf;

    };
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "docker" "cp" ];
        theme = "obraun";
      };
      shellAliases = {
        pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
        pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
        vim = "nvim";
      };
      interactiveShellInit = ''
        export BROWSER=chromium
        export TERM=xterm-256color
        export NIXPKGS_ALLOW_UNFREE=1
        export FZF_DEFAULT_COMMAND='ag -g ""'
        eval "$(direnv hook zsh)"
      '';
    };
  };

  environment = {

    variables = {
      KDEWM = "/run/current-system/sw/bin/i3";
      TERM = "xterm-256color";
      LC_ALL = "en_US.UTF-8";
      PAGER = "less -R";
      EDITOR = "nvim";
      ALTERNATE_EDITOR = "nano";
      NIXPKGS_UNSTABLE = "import (fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz) {}";
      FZF_DEFAULT_COMMAND = "ag -g \"\"";
      XCURSOR_THEME = "adwaita";
    };

    etc = {
      "Xmodmap".text = ''
        clear mod1
        clear mod4

        keycode 108 = Super_R NoSymbol Super_R
        keycode 134 = Alt_R Meta_R Alt_R Meta_R

        add mod1 = Alt_L Alt_R
        add mod4 = Super_L Super_R
      '';
    };
  };

  fonts = {
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      corefonts
      emojione
      fira
      fira-code
      fira-code-symbols
      fira-mono
      powerline-fonts
      font-awesome-ttf
    ];
  };

  networking = {
    networkmanager.enable = true;
    firewall.enable = false;
  };

  hardware = {
    bluetooth.enable = true;
    opengl.enable = true;
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.extraModules = [ pkgs.pulseaudio-modules-bt ];
    pulseaudio.extraConfig = ''
      load-module module-switch-on-connect
      load-module module-bluetooth-policy
      load-module module-bluetooth-discover
      load-module module-bluez5-device
      load-module module-bluez5-discover
    '';

  };

  services = {
    avahi.enable = true;
    blueman.enable = true;
    openssh.enable = true;
  };

  virtualisation = {
    virtualbox.host.enable = false;
    docker.enable = true;
    libvirtd.enable = true;
  };

  system.stateVersion = "20.03";
}
