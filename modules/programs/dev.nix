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
    zip
    unzip

    # docker
    colima
    docker-client
    docker-compose
    qemu
  ] ++ lib.optionals stdenv.isDarwin [
    claude-code
  ];

  imports = [
    ./ccache.nix
  ];
}
