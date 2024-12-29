{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.openssh
  ];

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "gitlab.com" = {
        identityFile = "~/.ssh/gitlab.com";
      };
      "github.com" = {
        identityFile = "~/.ssh/github.com";
      };
      "gitlab.kitware.com" = {
        identityFile = "~/.ssh/gitlab.kitware.com";
      };
    };
  };

  services.ssh-agent.enable = pkgs.stdenv.isLinux;
}
