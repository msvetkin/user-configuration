{ nixpkgs, nixgl, home-manager, username, ... }:
let
  pkgs = import nixpkgs {
    system = "x86_64-linux";
    overlays = [ nixgl.overlay ];
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
    };
  };
}
