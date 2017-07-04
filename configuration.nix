{ config, pkgs, ... }:

let

  i3Packages = with pkgs; {
    inherit i3 i3status feh terminator rofi-menugen networkmanagerapplet
      redshift base16 rofi rofi-pass i3lock-fancy xcape;
    inherit (xorg) xrandr xbacklight;
    inherit (pythonPackages) alot py3status;
    inherit (gnome3) gnome_keyring;

  };

  setxkbmapPackages = with pkgs.xorg; {
    inherit xinput xset setxkbmap xmodmap; };

  hsPackages = with pkgs.haskellPackages; [
    alex
    cabal2nix
    cabal-install
    ghc
    ghcid
    #ghc-mod
    happy
    hoogle
    hlint
    text
  ];

  npmPackages = with (import ./node-packages { inherit pkgs; }); [
    jsonlint
    replem
    tern
  ];

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
    options snd_hda_intel index=0 model=intel-mac-auto id=PCH
    options snd_hda_intel index=1 model=intel-mac-auto id=HDMI
    options snd_hda_intel model=mbp101
    options snd_hda_intel power_save=1
    options hid_apple fnmode=2
  '';
  boot.blacklistedKernelModules = [ "mei_me" ];

  networking.hostName = "monoid"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.enable = false;

  hardware.facetimehd.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;
  hardware.pulseaudio.extraConfig = ''
    load-module module-switch-on-connect
    '';

  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };

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
    arandr
    bundix
    compton
    nix-repl
    gitAndTools.hub
    gitAndTools.gitFull
    jq
    file
    #nox
    openssl
    silver-searcher
    tmux
    gnupg

    libreoffice

    emacs
    acpi
    lm_sensors
    bazaar
    chromium
    dmenu
    dunst
    evince
    gtk-engine-murrine
    gtk_engines
    hexchat
    htop
    jq
    libnotify
    lxappearance
    mbpfan
    nodejs-7_x
    ncdu

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
    vpnc
    openfortivpn
    openvpn
    oh-my-zsh

    pasystray
    pavucontrol

    shellcheck
    thunderbird

    #steam
    #spotify

    slack
    fzf
    python
    pass
    psmisc
    iotop
    rofi
    silver-searcher
    terminator
    tmux
    unclutter
    unzip
    vlc
    wget
    xcape
    xclip
    xfce.xfce4volumed
    xfce.xfce4_power_manager
    xlibs.xbacklight
    xlibs.xcursorthemes
    xlibs.xev
    xlibs.xmodmap
    xlibs.xset
    xsel

    volumeicon
  ] ++ hsPackages
    ++ npmPackages;

  programs.zsh.enable = true;

  # Configure nixpkgs
  nixpkgs.config = {
    allowUnfree = true;
    allowUnfreeRedistributable = true;
    chromium = {
      enablePepperFlash = false;
      enablePepperPDF = true;
    };
    permittedInsecurePackages = [
        "libplist-1.12"
      ];
  };

  nix = {
    gc = {
      automatic = true;
    };
    extraOptions = ''
      auto-optimise-store = true
    '';
    trustedBinaryCaches = [ "http://ci.hcweb.aws.hc.lan:8081" ];
    requireSignedBinaryCaches = false;
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
      emojione
      freefont_ttf
      nerdfonts
      liberation_ttf
      source-code-pro
      terminus_font
      ttf_bitstream_vera
      ubuntu_font_family
    ];
  };

  systemd.user.services.powertop = {
    enable = true;
    description = "powertop autotune service";
    wantedBy = [ "multi-user.target" ];
    path = with pkgs; [ powertop ];
    serviceConfig = {
      ExecStart = "${pkgs.powertop}/bin/powertop --auto-tune";
      Type = "oneshot";
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
  services.printing.enable = true;
  services.dbus.enable = true;
  services.openssh.enable = true;
  services.upower.enable = true;
  services.mbpfan.enable = true;
  services.acpid.enable = true;
  services.acpid.lidEventCommands = ''
    LID_STATE=/proc/acpi/button/lid/LID0/state
    if [ $(/run/current-system/sw/bin/awk '{print $2}' $LID_STATE) = 'closed' ]; then
      systemctl suspend
    fi
  '';
  services.tlp.enable = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  users.extraGroups.docker.members = [ "gilligan" ];
  #users.extraGroups.libvirtd.members = [ "gilligan" ];
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    displayManager = {
      slim.enable = true;
      slim.defaultUser = "gilligan";
      sessionCommands = ''
        gpg-connect-agent /bye
        GPG_TTY=$(tty)
        export GPG_TTY
      '';
    };

    desktopManager.xterm.enable = false;
    desktopManager.default= "none";

    windowManager.default = "i3";
    windowManager.i3.enable = true;

    libinput = {
      enable = true;
      tapping = false;
      clickMethod = "clickfinger";
      disableWhileTyping = true;
      scrollMethod = "twofinger";
      naturalScrolling = true;
    };

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
