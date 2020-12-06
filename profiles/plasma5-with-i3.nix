{ config, lib, pkgs, ... }:

{

  services = {
    xserver = {
      enable = true;

      desktopManager = {
        plasma5.enable = true;
        xterm.enable = true;
      };

      displayManager = {
        defaultSession = "plasma5+i3";
        sessionCommands = ''
          gpg-connect-agent /bye
          GPG_TTY=$(tty)
          export GPG_TTY
          export XCURSOR_PATH=${pkgs.gnome3.adwaita-icon-theme}/share/icons
        '';
      };

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

  environment = {
    systemPackages = with pkgs; [
      chromium
      slack
      signal-desktop
      spotify
      zoom-us
    ];
    variables = {
      KDEWM = "/run/current-system/sw/bin/i3";
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

}
