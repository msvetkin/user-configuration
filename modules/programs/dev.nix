{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    # ctags
    # cmake
    # clang-tools
    # cmake
    ninja
    gdb
    gnumake
    pre-commit
    # python3
    nodejs
    zip
    unzip
  ] ++ lib.optionals stdenv.isDarwin [
    claude-code
  ];

  imports = [
    ./ccache.nix
  ];
}
