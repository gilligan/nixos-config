self: super:
let
  sources = import ../nix/sources.nix;
  nixpkgs-unstable = import sources.nixpkgs-unstable {
    config = { allowUnfree = true; };
  };
in
{
  plug-vim = self.writeTextFile {
    name = "plug.vim";
    text = self.lib.fileContents ../assets/plug.vim;
    destination = "/plug.vim";
  };

  neovim = nixpkgs-unstable.neovim.override {
    withNodeJs = true;
    configure = {
      customRC = ''
        source ${self.plug-vim}/plug.vim

        ${builtins.readFile ../assets/vimrc}

        if filereadable(expand('~/.config/nvim/local.vim'))
        source ~/.config/nvim/local.vim
        endif
      '';
    };
  };

}
