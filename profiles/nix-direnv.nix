{ config, lib, pkgs, ... }:
{
  environment = {
    systemPackages = with pkgs; [
      nix-direnv
    ];
    pathsToLink = [
      "/share/nix-direnv"
    ];
  };
}
