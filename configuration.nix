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
      extraConfig = ''
        # Use something easier to type as the prefix.
        set -g prefix C-f
        unbind C-b
        bind C-f send-prefix

        # Relax!
        set -sg escape-time 0
        set -sg repeat-time 600

        # Less stretching to get to the first item.
        set -g base-index 1
        setw -g pane-base-index 1

        # Reload the config.
        bind r source-file ~/.tmux.conf \; display "Reloaded ~/.tmux.conf"

        unbind t
        # Saner splitting.
        bind v split-window -h
        bind s split-window -v

        # Pane movement
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Pane resizing
        bind -r Left  resize-pane -L 2
        bind -r Down  resize-pane -D 2
        bind -r Up    resize-pane -U 2
        bind -r Right resize-pane -R 2

        # Window movement
        bind -r , select-window -t :-
        bind -r . select-window -t :+

        # 256 colors please
        set -g default-terminal "screen-256color"
        setw -g xterm-keys on
        # in fact, gimmie true color please
        set-option -ga terminal-overrides ",xterm-256color:Tc"

        #set -g window-status fg=white bg=colour234
        set -g window-status-activity bold

        set -g status-left-length 32
        set -g status-right-length 150
        set -g status-interval 5

        set -g status-left '#[default]'
        set -g status-right '#[bold]#(whoami)@#H#[default] ⡇ #[fg=blue]%H:%M#[default] '

        # Activity
        setw -g monitor-activity on
        set -g visual-activity off

        # Autorename sanely.
        setw -g automatic-rename on

        # Better name management
        bind c new-window \; command-prompt "rename-window '%%'"
        bind C new-window
        bind , command-prompt "rename-window '%%'"

        # Copy mode
        setw -g mode-keys vi
        bind [ copy-mode
        unbind p
        bind p paste-buffer
        bind -T copy-mode-vi v send-keys -X begin-selection
        bind -T copy-mode-vi y send-keys -X copy-selection

        is_vim='tmux show-environment #{pane_id}_is_vim'
        bind -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
        bind -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
        bind -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
        bind -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
        bind -n C-\ if-shell "$is_vim" "send-keys C-\\" "select-pane -l"


        # default statusbar colors
        set-option -g status-bg white #base2
        set-option -g status-fg yellow #yellow, default

        # pane border
        set-option -g pane-active-border fg=brightcyan #base1

        # message text
        #set-option -g message bg=white #base2 fg=brightred #orange

        # pane number display
        set-option -g display-panes-active-colour blue #blue
        set-option -g display-panes-colour brightred #orange

        # clock
        set-window-option -g clock-mode-colour green #green

        # bell
        set-window-option -g window-status-bell-style fg=white,bg=red #base2, red
      '';

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
      };
      interactiveShellInit = ''
        export BROWSER=chromium
        export TERM=xterm-256color
        export NIXPKGS_ALLOW_UNFREE=1
        export FZF_DEFAULT_COMMAND='ag -g ""'
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
