{ config, pkgs, ... }:
let
  vimCommon = import ./common.nix {
    inherit pkgs;
  };
  cocConfig = import ./coc.nix {
    inherit pkgs;
  };
  vimCppModern = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-cpp-modern";
    src = pkgs.fetchFromGitHub {
      owner = "bfrg";
      repo = "vim-cpp-modern";
      rev = "0f0529bf2a336a4e824a26b733220548d32697a6";
      hash = "sha256-TseU3nW891sCYcjejkuAJDXf2zBl4W6eG+IoPifbVBY=";
    };
  };
  vimCppModernConfig = ''
    let g:cpp_class_scope_highlight = 1
    let g:cpp_attributes_highlight = 1
    let g:cpp_member_highlight = 1
  '';
in {
  programs.vim = {
    enable = vimCommon.enable;
    defaultEditor = vimCommon.defaultEditor;
    plugins = vimCommon.plugins ++ cocConfig.plugins ++ [ vimCppModern ];
    extraConfig = vimCommon.extraConfig + "\n" + cocConfig.extraConfig + "\n" + vimCppModernConfig;
  };

  home.packages = cocConfig.packages;
}
