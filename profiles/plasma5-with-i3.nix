{ config, lib, pkgs, ... }:

let
  i3-wrapper = pkgs.writeScriptBin "i3"
    ''
      exec ${pkgs.i3-gaps}/bin/i3 -c ${pkgs.i3-config-file}
    '';
in

{

  services = {
    xserver = {
      enable = true;

      desktopManager = {
        plasma5.enable = true;
        xterm.enable = true;
      };

      displayManager = {
        defaultSession = "plasma+i3";
        session = [
          {
            manage = "desktop";
            name = "plasma+i3";
            start = ''
              exec env KDEWM=${i3-wrapper}/bin/i3 ${pkgs.plasma-workspace}/bin/startplasma-x11
            '';
          }
        ];
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
      XCURSOR_SIZE = "64";
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
