{ pkgs ? import ./nix }:
let
  pre-commit-hooks = pkgs.nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixpkgs-fmt = {
        excludes = [ ".*nix/sources.nix$" ];
        enable = true;
      };
    };
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [ git nixpkgs-fmt niv gnumake ];
  NIXOS_CONFIG = ./configuration.nix;
  NIX_PATH = "nixpkgs=${pkgs.path}";
  inherit (pre-commit-hooks) shellHook;
}
