{ pkgs, lib, ... }:
{
  hardware = {
    pulseaudio.enable = true;
    pulseaudio.package = pkgs.pulseaudioFull;
    pulseaudio.extraConfig = ''
      load-module module-switch-on-connect
    '';
  };
}
