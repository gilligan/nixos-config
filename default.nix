{ pkgs ? import ./nix }:
let
  nixos = pkgs.nixos;
  buildSys = p: (nixos p).config.system.build.toplevel;
in
{
  toontown = (buildSys ./machines/toontown/configuration.nix);
  semigroup = (buildSys ./machines/semigroup/configuration.nix);
}
