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
        defaultSession = "plasma";
        sessionCommands = ''
          gpg-connect-agent /bye
          GPG_TTY=$(tty)
          export GPG_TTY
          export XCURSOR_PATH=${pkgs.gnome3.adwaita-icon-theme}/share/icons
          ${pkgs.xlibs.xsetroot}/bin/xsetroot -cursor_name ${pkgs.gnome3.adwaita-icon-theme}/share/icons/Adwaita/cursors/left_ptr 64
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
      google-chrome
      slack
      signal-desktop
      spotify
      xsel
      zoom-us
    ];
    variables = {
      KDEWM = "/run/current-system/sw/bin/i3";
      XCURSOR_THEME = "Adwaita";
      XCURSOR_SIZE = "32";
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
    fontDir.enable = true;
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
      nerdfonts
    ];
  };

}
