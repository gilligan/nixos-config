{ pkgs ? import ./nix }:
let
  pre-commit-hooks = pkgs.nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      nixpkgs-fmt.enable = true;
    };
  };
in
pkgs.mkShell {
  buildInputs = with pkgs; [ nixpkgs-fmt niv ];
  NIX_PATH = ./nix;
  inherit (pre-commit-hooks) shellHook;
}
