{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.meld
  ];

  # xdg.systemDirs.data = [
    # "\${XDG_DATA_DIRS}:${pkgs.git}/share/git/contrib/completion:"
  # ];

  programs.difftastic = {
    enable = true;
    git.enable = true;
    options.background = "dark";
  };

  programs.git = {
    enable = true;
    settings.alias = {
      meld = "difftool -y -t meld";
    };
    lfs.enable = true;
  };
}
