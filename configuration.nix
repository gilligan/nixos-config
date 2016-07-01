{ config, pkgs, ... }:

let

  i3Packages = with pkgs; {
    inherit i3 i3status feh terminator rofi-menugen networkmanagerapplet
      redshift base16 rofi rofi-pass i3lock-fancy xcape;
    inherit (xorg) xrandr xbacklight;
    inherit (pythonPackages) ipython alot py3status;
    inherit (gnome3) gnome_keyring;

  };

  setxkbmapPackages = with pkgs.xorg; { inherit xinput xset setxkbmap xmodmap; };

in {

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  environment.etc."Xmodmap".text = import ./pkgs/xmodmap_config.nix { };

  environment.etc."i3/config".text = import ./pkgs/i3_config.nix (i3Packages // {
    inherit (pkgs) lib writeScript;
  });

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.initrd.kernelModules = [ "fbcon" ];
  boot.cleanTmpDir = true;
  boot.extraModprobeConfig = ''
    options libata.force=noncq
    options resume=/dev/sda5
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd_hda_intel model=mbp101
    options hid_apple fnmode=2
  '';

  networking.hostName = "monoid"; # Define your hostname.
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  powerManagement.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs;
    (builtins.attrValues (
      i3Packages //
      setxkbmapPackages //
      {})) ++
    [
    nix-repl
    gitAndTools.hub
    gitAndTools.gitFull
    jq
    nox
    openssl
    silver-searcher
    tmux
    groovy
    python

    acpi
    lm_sensors
    bazaar
    chromium
    dmenu
    dunst
    git
    gtk-engine-murrine
    gtk_engines
    hexchat
    htop
    jq
    lxappearance

    (neovim.override {
      vimAlias = true;
      configure = {
        customRC = '';
	    set rtp+=~/.nvim
	    source ~/.nvim/nvimrc
        call remote#host#RegisterPlugin('python3', '/home/gilligan/.nvim/plugged/deoplete.nvim/rplugin/python3/deoplete', [
              \ {'sync': 1, 'name': '_deoplete', 'type': 'function', 'opts': {}},
             \ ])

	  '';
      };
    })

    networkmanagerapplet
    networkmanager_vpnc
    nox
    openfortivpn
    openvpn

    python
    rofi
    silver-searcher
    terminator
    tmux
    udisks_glue
    unclutter
    unzip
    wget
    xcape
    xclip
    xlibs.xbacklight
    xlibs.xcursorthemes
    xlibs.xev
    xlibs.xmodmap
    xlibs.xset
  ];

  programs.zsh.enable = true;

  # Configure nixpkgs
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    chromium = {
      enablePepperFlash = true;
      enablePepperPDF = true;
    };
  };

  # Configure fonts
  fonts = {
    enableCoreFonts = true;
    enableFontDir = true;
    enableGhostscriptFonts = true;
    fonts = with pkgs; [
      anonymousPro
      corefonts
      dejavu_fonts
      freefont_ttf
      liberation_ttf
      nerdfonts
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      var YES = polkit.Result.YES;
      // NOTE: there must be a comma at the end of each line except for the last:
      var permission = {
        // required for udisks1:
        "org.freedesktop.udisks.filesystem-mount": YES,
        "org.freedesktop.udisks.luks-unlock": YES,
        "org.freedesktop.udisks.drive-eject": YES,
        "org.freedesktop.udisks.drive-detach": YES,
        // required for udisks2:
        "org.freedesktop.udisks2.filesystem-mount": YES,
        "org.freedesktop.udisks2.encrypted-unlock": YES,
        "org.freedesktop.udisks2.eject-media": YES,
        "org.freedesktop.udisks2.power-off-drive": YES,
        // required for udisks2 if using udiskie from another seat (e.g. systemd):
        "org.freedesktop.udisks2.filesystem-mount-other-seat": YES,
        "org.freedesktop.udisks2.filesystem-unmount-others": YES,
        "org.freedesktop.udisks2.encrypted-unlock-other-seat": YES,
        "org.freedesktop.udisks2.eject-media-other-seat": YES,
        "org.freedesktop.udisks2.power-off-drive-other-seat": YES
      };
      if (subject.isInGroup("wheel")) {
        return permission[action.id];
      }
    });
  '';

  systemd.user.services.udiskie = {
    enable = false;
    description = "Removable disk automounter";
    wantedBy = [ "default.target" ];
    path = with pkgs; [
      gnome3.defaultIconTheme
      gnome3.gnome_themes_standard
      pythonPackages.udiskie
    ];
    environment.XDG_DATA_DIRS="${pkgs.gnome3.defaultIconTheme}/share:${pkgs.gnome3.gnome_themes_standard}/share";
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.pythonPackages.udiskie}/bin/udiskie --automount --notify --tray --use-udisks2";
    };
  };

  systemd.user.services.dunst = {
    enable = false;
    description = "Lightweight and customizable notification daemon";
    wantedBy = [ "default.target" ];
    path = [ pkgs.dunst ];
    serviceConfig = {
      Restart = "always";
      ExecStart = "${pkgs.dunst}/bin/dunst";
    };
  };

  # List services that you want to enable:

  services.nixosManual.showManual = true;
  services.dbus.enable = true;
  services.openssh.enable = true;
  services.upower.enable = true;
  services.acpid.enable = true;
  services.acpid.lidEventCommands = ''
    LID_STATE=/proc/acpi/button/lid/LID0/state
    if [ $(/run/current-system/sw/bin/awk '{print $2}' $LID_STATE) = 'closed' ]; then
      systemctl suspend
    fi
  '';

  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "gilligan" ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      slim.enable = true;
      slim.defaultUser = "gilligan";
    };

    desktopManager.xterm.enable = false;
    desktopManager.default= "none";

    windowManager.default = "i3";
    windowManager.i3.enable = true;

    synaptics.enable = true;
    synaptics.buttonsMap = [ 1 3 2 ];
    synaptics.tapButtons = true;
    synaptics.twoFingerScroll = true;
    synaptics.vertEdgeScroll = false;
    synaptics.minSpeed = "0.6";
    synaptics.maxSpeed = "60";
    synaptics.accelFactor = "0.0075";
    synaptics.palmDetect = true;
    synaptics.horizontalScroll = true;
    synaptics.additionalOptions = ''
      Option "VertScrollDelta" "-130"
      Option "HorizScrollDelta" "-130"
      Option "FingerLow" "40"
      Option "FingerHigh" "60"
    '';

    xkbOptions = "terminate:ctrl_alt_bksp, ctrl:nocaps";
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.gilligan= {
    isNormalUser = true;
    group = "users";
    uid = 1000;
    extraGroups = [ "wheel" "networkmanager" ];
    createHome = true;
    home = "/home/gilligan";
    shell = "/run/current-system/sw/bin/zsh";
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "16.03";

}
