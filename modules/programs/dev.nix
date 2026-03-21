{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ctags
    # cmake
    # clang-tools
    #cmake
    # ninja
    # gdb
    # gnumake
    # pre-commit
    # python3
    #zip
    #unzip
  ];

  imports = [
    ./ccache.nix
  ];
}
