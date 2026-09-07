{ nixpkgs, home-manager, username, ... }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
      "nvidia-x11"
    ];
    config.nvidia.acceptLicense = true;
  };
in
{
  laptop = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules = [ ./home.nix ];
    extraSpecialArgs = {
      username = "${username}";
      configuration = "laptop";
      isLaptop = true;
      displays = [ "eDP-1" ];
      hasNvidia = true;
    };
  };

  desktop = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules = [ ./home.nix ];
    extraSpecialArgs = {
      username = "${username}";
      configuration = "desktop";
      isLaptop = false;
      displays = [ "HDMI-0" "DP-0" ];
      hasNvidia = true;
    };
  };

  galactica = home-manager.lib.homeManagerConfiguration {
    inherit pkgs;

    modules = [ ./home.nix ];
    extraSpecialArgs = {
      username = "${username}";
      configuration = "galactica";
      isLaptop = false;
      displays = [ "DP-2-1" "HDMI-1" "DP-2-8" ];
      hasNvidia = false;
    };
  };
}
