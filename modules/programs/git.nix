{ config, pkgs, ... }:

{
  home.packages = [
    pkgs.meld
  ];

  # xdg.systemDirs.data = [
    # "\${XDG_DATA_DIRS}:${pkgs.git}/share/git/contrib/completion:"
  # ];

  programs.git = {
    enable = true;
    settings = {
      alias = {
        meld = "difftool -y -t meld";
      };
    };
    lfs.enable = true;
  };

  programs.difftastic = {
    enable = true;
    options = {
      background = "dark";
    };
  };
}
