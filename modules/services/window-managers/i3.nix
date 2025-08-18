{ config, lib, pkgs, displays, ... }:

with lib;

let
  mod = "Mod4";
  alt = "Mod1";
  mode_system = "System (l) lock, (e) exit, (s) suspend, (h) hibernate, (r) reboot, (S) Shutdown";
  workspaces = import ./workspace-config.nix {
    inherit lib;
    displays = displays;
  };
  workspaceForChats = (builtins.elemAt workspaces 8).workspace;
  workspaceForAudio = (builtins.elemAt workspaces 11).workspace;

  bars = import ./bar-config.nix {
    inherit config;
    inherit pkgs;
    displays = displays;
  };

in {
  imports = [
    ./../../programs/autorandr.nix
    ./../../programs/rofi.nix
    ./../../programs/i3status-rust.nix
    ./../../programs/variety/variety.nix
  ];

  home.packages = [
    pkgs.scrot
    pkgs.xxkb
    pkgs.feh
    pkgs.arandr

    # exec command for lightdm /usr/share/xsessions/nix-i3.desktop
    # empty because lightdm source .xprofile which starts i3
    (pkgs.writeShellScriptBin "i3-session-target" ''
    '')
  ];

  xsession = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      config = {
        modifier = mod;
        floating = {
          modifier = alt;
        };
        fonts = {
          names = [ "Liberation Mono" ];
          size = 11.0;
        };
        window = {
          titlebar = false;
          border = 3;
        };
        floating = {
          titlebar = false;
          border = 3;
          criteria = [
            { "class" = "app"; }
            { "class" = "Wine"; }
            { "class" = "QtQmlViewer"; }
          ];
        };
        gaps = {
          inner = 6;

          smartBorders = "on";
          smartGaps = true;

          outer = 2;
        };
        assigns = {
          "${workspaceForChats}" = [
            { class = "^TelegramDesktop$"; }
            { class = "^Slack$"; }
            { class = "^Discord$"; }
          ];
          "${workspaceForAudio}" = [
            { class = "^Pavucontrol$"; }
          ];
        };
        keybindings = {
          "${mod}+Shift+space" = "floating toggle";
          "${mod}+space" = "focus mode_toggle";
          "${mod}+t" = "exec i3-sensible-terminal";
          "${mod}+c" = "kill";
          "${mod}+Shift+c" = "reload";
          "${mod}+Shift+r" = "restart";

          "${mod}+Insert" = "mode \"${mode_system}\"";

          "${mod}+r" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show run -terminal i3-sensible-terminal";
          "${mod}+p" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show window -terminal i3-sensible-terminal";
          "${mod}+s" = "exec --no-startup-id ${pkgs.rofi}/bin/rofi -show ssh -terminal i3-sensible-terminal";
          "--release Print" = "exec ${pkgs.scrot}/bin/scrot '%d.%m.%Y-%H:%M:%S.png' -e 'mkdir -p ~/screenshots && mv $f ~/screenshots'";
          "--release Shift+Print" = "exec ${pkgs.scrot}/bin/scrot -s '%d.%m.%Y-%H:%M:%S.png' -e 'mkdir -p ~/screenshots && mv $f ~/screenshots'";
          "XF86AudioRaiseVolume" = "exec --no-startup-id pactl set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "exec --no-startup-id pactl set-sink-volume 0 -5%";
          "XF86AudioMute" = "exec --no-startup-id pactl set-sink-mute 0 toggle";
          "XF86AudioMicMute" = "exec --no-startup-id pactl set-source-mute 1 toggle";

          "${mod}+Shift+i" = "move scratchpad";
          "${mod}+i" = "scratchpad show";
          "${mod}+Shift+f" = "scratchpad show, fullscreen";

          "${mod}+x" = "[urgent=latest] focus";
          "${alt}+Tab" = "focus output right";
          "${mod}+h" = "focus left";
          "${mod}+j" = "focus down";
          "${mod}+k" = "focus up";
          "${mod}+l" = "focus right";
  "${alt}+Shift+Tab" = "focus output left"; "${mod}+Shift+h" = "move left";

          "${mod}+Shift+j" = "move down";
          "${mod}+Shift+k" = "move up";
          "${mod}+Shift+l" = "move right";
          "${mod}+Shift+Left" = "move left";
          "${mod}+Shift+Down" = "move down";
          "${mod}+Shift+Up" = "move up";
          "${mod}+Shift+Right" = "move right";

          "${mod}+f" = "fullscreen";
          "${mod}+${alt}+h" = "split h";
          "${mod}+${alt}+v" = "split v";
          "${mod}+${alt}+s" = "layout stacking";
          "${mod}+${alt}+t" = "layout tabbed";
          "${mod}+${alt}+o" = "layout toggle split";

          "Ctrl+b" = "workspace back_and_forth";
        } //

        builtins.listToAttrs (builtins.genList (i: {
          name = "Ctrl+F" +  toString (i + 1);
          value = "workspace " + (builtins.elemAt workspaces i).workspace;
        }) (builtins.length workspaces)) //

        builtins.listToAttrs (builtins.genList (i: {
          name = "${mod}+F" +  toString (i + 1);
          value = "move container to workspace " + (builtins.elemAt workspaces i).workspace;
        }) (builtins.length workspaces)) //

        builtins.listToAttrs (builtins.genList (i: {
          name = "${mod}+Ctrl+F" +  toString (i + 1);
          value = "move container to workspace" + (builtins.elemAt workspaces i).workspace + ", workspace " + (builtins.elemAt workspaces i).workspace;
        }) (builtins.length workspaces));

        modes = {
          resize = {};
          "${mode_system}" = {
            "l" = "exec --no-startup-id i3lock lock, mode \"default\"";
            "e" = "exec --no-startup-id ${pkgs.i3}/bin/i3-msg exit, mode \"default\"";
            "s" = "exec --no-startup-id i3lock lock && systemctl suspend, mode \"default\"";
            "h" = "exec --no-startup-id i3lock lock && systemctl hibernate, mode \"default\"";
            "r" = "exec --no-startup-id systemctl reboot, mode \"default\"";
            "Shift+s" = "exec --no-startup-id systemctl poweroff, mode \"default\"";
            "Return" = "mode \"default\"";
            "Escape" = "mode \"default\"";
          };
        };

        workspaceOutputAssign = lib.mkOptionDefault workspaces;

        bars = bars;

        startup = [
          { command = "autorandr --change"; notification = false; }
          { command = "xxkb"; notification = false; }
          { command = "xset b off"; notification = false; }
          { command = "sleep 10s && ${pkgs.variety}/bin/variety --next"; notification = false; }
          { command = "xfce4-power-manager"; notification = false; }
          { command = "xfce4-power-manager-setting"; notification = false; }
        ];
      };
    };
  };
}
