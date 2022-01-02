{ pkgs ? import ./nix }:
let
  nixos = pkgs.nixos;
in
{
  toontown = (nixos ./machines/toontown/configuration.nix);
  semigroup = (nixos ./machines/semigroup/configuration.nix);
}
