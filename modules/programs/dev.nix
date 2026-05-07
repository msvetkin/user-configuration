{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    claude-code

    # ctags
    # cmake
    # clang-tools
    # cmake
    ninja
    gdb
    gnumake
    pre-commit
    # python3
    zip
    unzip

    # docker
    colima
    docker-client
    docker-compose
    qemu
  ];

  imports = [
    ./ccache.nix
  ];
}
