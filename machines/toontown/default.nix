{ pkgs ? import ../../nix }:
let
  nixos = pkgs.nixos;
  buildSys = p: (nixos p).config.system.build.toplevel;
  configDir = toString ./.;
in
{
  system = buildSys ./configuration.nix;
  rebuild = pkgs.writeShellScript "rebuild" ''
    PATH="${pkgs.nix}/bin:$PATH"
    set -exu
    set -o pipefail
    ACTIVATION_SCRIPT=$(nix-build --no-out-link ${configDir} -A system)/bin/switch-to-configuration
    exec $ACTIVATION_SCRIPT "$@"
  '';
}
