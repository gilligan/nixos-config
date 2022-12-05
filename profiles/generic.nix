{ config, lib, pkgs, ... }:
{
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";

  boot = {
    loader.systemd-boot.enable = true;
    cleanTmpDir = true;
  };

  nix = {
    settings = {
      sandbox = true;
    };
    gc = {
      automatic = true;
    };
    extraOptions = ''
      auto-optimise-store = true
      keep-outputs = true
      keep-derivations = true
    '';
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "qt";
    enableSSHSupport = true;
  };

  services = {
    avahi.enable = true;
    openssh.enable = true;
  };
}
