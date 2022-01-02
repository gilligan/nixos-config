let
  pins = import ../npins/default.nix;
  config = {
    allowUnfree = true;
  };
  overlays = [
    (self: super: { nix-pre-commit-hooks = import pins."pre-commit-hooks.nix"; })
    (self: super: { sorri = self.callPackage pins.sorri { }; })
    (self: super: { nix-direnv = self.callPackage pins.nix-direnv { }; })
    (self: super: { npins = self.callPackage pins.npins { }; })
    (self: super: { my-neovim = self.callPackage pins.neovim-nix { }; })
  ];
in
import pins.nixpkgs { inherit overlays config; }
