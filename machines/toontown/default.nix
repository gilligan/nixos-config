{ pkgs ? import ../../nix }:
let
  nixos = pkgs.nixos;
  buildSys = p: (nixos p);
  sys = (buildSys ./configuration.nix);
  configDir = toString ./.;
in
rec {
  system = sys.config.system.build.toplevel;
  rebuild = pkgs.writeShellScript "rebuild" ''
    PATH="${sys.config.nix.package}/bin:$PATH"
    set -exu
    set -o pipefail
    PROFILE=$(nix-build --no-out-link ${configDir} -A system)
    ACTIVATION_SCRIPT=$PROFILE/bin/switch-to-configuration
    if [[ "$1" = switch || "$1" = boot ]]; then
      nix-env -p "/nix/var/nix/profiles/system" --set $PROFILE
    fi
    exec $ACTIVATION_SCRIPT "$@"
  '';
}
