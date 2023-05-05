{ config, lib, pkgs, ... }:
{
  console = {
    font = "ter-i32b";
    keyMap = "us";
    packages = with pkgs; [ terminus_font ];
  };

  environment = {
    variables = {
      TERM = "xterm-256color";
      LC_ALL = "en_US.UTF-8";
      PAGER = "less -R";
      EDITOR = "nvim";
      ALTERNATE_EDITOR = "nano";
      NIXPKGS_UNSTABLE = "import (fetchTarball https://nixos.org/channels/nixpkgs-unstable/nixexprs.tar.xz) {}";
      FZF_DEFAULT_COMMAND = "ag -g \"\"";
    };
    systemPackages = with pkgs; [
      silver-searcher
      direnv
      entr
      file
      fzf
      gitAndTools.gitFull
      gitAndTools.hub
      gitAndTools.tig
      jq
      killall
      npins
      neovim-nix
      nix-index
      ripgrep
      shellcheck
      tmate
      wget
    ];
  };

  programs = {
    command-not-found.enable = true;
    tmux = {
      enable = true;
      terminal = "screen-256color";
      extraConfig = builtins.readFile ../assets/tmux.conf;

    };
    zsh = {
      enable = true;
      enableCompletion = true;
      ohMyZsh = {
        enable = true;
        plugins = [ "git" "docker" "cp" ];
        theme = "obraun";
      };
      shellAliases = {
        pbcopy = "${pkgs.xclip}/bin/xclip -selection clipboard";
        pbpaste = "${pkgs.xclip}/bin/xclip -selection clipboard -o";
        docker-clean = "docker rm --force $(docker ps -a -q) && docker rmi --force $(docker images -q)";
        vim = "nvim";
      };
      interactiveShellInit = ''
        export BROWSER=google-chrome-stable
        export TERM=xterm-256color
        export NIXPKGS_ALLOW_UNFREE=1
        export FZF_DEFAULT_COMMAND='ag -g ""'
        eval "$(direnv hook zsh)"
      '';
    };
  };
}
