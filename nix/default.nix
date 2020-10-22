let
  sources = import ./sources.nix;
  overlays = [
    (self: super: { nix-pre-commit-hooks = import sources."pre-commit-hooks.nix"; })
  ];
in
import sources.nixpkgs { inherit overlays; }
