{ pkgs, username, ... }:
let

in
{
  nix.package = pkgs.nix;
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = "nix-command flakes";

  # Set Git commit hash for darwin-version.
  #system.configurationRevision = self.rev or self.dirtyRev or null;

  programs.zsh.enable = true;

  system.stateVersion = 6;
  system.primaryUser = "${username}";
  ids.gids.nixbld = 30000;

  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users."${username}".home = "/Users/${username}";
  security.pam.services.sudo_local.touchIdAuth = true;

  homebrew = {
    enable = true;
    brews = [
      "java"
      "openjdk@17"
      "openjdk@11"
      "cmake"
      "pkg-config"
      "ninja"
      "zip"
      "unzip"
      "colima"
      "docker"
      "pre-commit"
      "autoconf"
      "automake"
      "m4"
      "libtool"
      "autoconf-archive"
      "ffmpeg"
    ];
    onActivation = {
      cleanup = "zap";

      # updates homebrew packages on activation,
      # can make darwin-rebuild much slower (otherwise i'd forget to do it ever though)
      #autoUpdate = true;
      #upgrade = true;
    };
    casks = [
      "wezterm"
    ];
  };
}
