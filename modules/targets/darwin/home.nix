{ config, pkgs, configuration, ... }:
let

in {
  home.packages = [
    (pkgs.writeShellScriptBin "home-manager-switch" ''
      sudo darwin-rebuild switch \
        --flake ~/code/github/user-configuration#${configuration}
    '')
    (pkgs.writeShellScriptBin "home-manager-build" ''
      sudo darwin-rebuild build \
        --flake ~/code/github/user-configuration#${configuration}
    '')
  ];

  imports = [
    ../common.nix
    ../../programs/dev.nix
    ../../programs/vim/neovim.nix
    ../../programs/messenger.nix
  ];
}
