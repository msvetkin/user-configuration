{ config, pkgs, ... }:
let
  vimCommon = import ./common.nix {
    inherit pkgs;
  };
  cocConfig = import ./coc.nix {
    inherit pkgs;
  };
in {
  # programs.neovim = vimCommon // {
    # vimAlias = true;
    # extraConfig = vimCommon.extraConfig + ''
      # let g:neovide_cursor_animation_length = 0
      # let g:neovide_cursor_trail_size = 0
    # '';
  # };

  programs.neovim = {
    vimAlias = true;
    enable = vimCommon.enable;
    defaultEditor = vimCommon.defaultEditor;
    plugins = vimCommon.plugins ++ cocConfig.plugins;
    extraConfig = vimCommon.extraConfig + "\n" + cocConfig.extraConfig + ''
      let g:neovide_cursor_animation_length = 0
      let g:neovide_cursor_trail_size = 0
      let g:neovide_scroll_animation_length = 0
    '';
  };

  home.packages = [
    pkgs.neovide
  ] ++ cocConfig.packages;

  programs.zsh.shellAliases = {
    gvim = "${pkgs.neovide}/bin/neovide";
  };
}
