{ config, pkgs, ... }:

{
  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      shellAliases = {
        ls = "ls -a --color=auto";
        ll = "ls -l";
      };
      initExtra = ''
        PAGER='less -X -F';
        if [[ $(uname -m) == 'arm64' ]]; then
             eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      '';
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        # theme = "philips";
        plugins = [
          "gitfast"
        ];
      };
      plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.5.0";
              sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
            };
          }
        ];
    };
    dircolors = {
      enableZshIntegration = true;
    };
  };
}
