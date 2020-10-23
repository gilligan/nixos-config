let
  sources = import ./sources.nix;
  config = {
    allowUnfree = true;
  };
  overlays = [
    (self: super: { nix-pre-commit-hooks = import sources."pre-commit-hooks.nix"; })
    (self: super: { sorri = self.callPackage sources.sorri { }; })
  ];
in
import sources.nixpkgs { inherit overlays config; }
