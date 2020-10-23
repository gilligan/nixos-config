self: super:
{
  plug-vim = self.writeTextFile {
    name = "plug.vim";
    text = self.lib.fileContents ../assets/plug.vim;
    destination = "/plug.vim";
  };

  neovim = super.neovim.override {
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
