{ config, pkgs, ... }:
let

in {
  home.packages = [
    pkgs.rofi
    pkgs.scrot
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    # settings = {
      # autogenerated = 1;
      # monitor = ",preferred,auto,auto";
      # env = "XCURSOR_SIZE,24";

     # input = {
       # kb_layout = "us,ru";
       # options = [ "grp:toggle" ];
       # follow_mouse = 1;
       # # accel_profile = "flat";
       # # touchpad = { scroll_factor = 0.3; };
     # };
    # };
    extraConfig = ''
########################################################################################
AUTOGENERATED HYPR CONFIG.
PLEASE USE THE CONFIG PROVIDED IN THE GIT REPO /examples/hypr.conf AND EDIT IT,
OR EDIT THIS ONE ACCORDING TO THE WIKI INSTRUCTIONS.
########################################################################################

#
# Please note not all available settings / options are set here.
# For a full list, see the wiki
#

#autogenerated = 1 # remove this line to remove the warning

# See https://wiki.hyprland.org/Configuring/Monitors/
monitor=,preferred,auto,auto


# See https://wiki.hyprland.org/Configuring/Keywords/ for more

# Execute your favorite apps at launch
# exec-once = waybar & hyprpaper & firefox

# Source a file (multi-file configs)
# source = ~/.config/hypr/myColors.conf

# Some default env vars.
env = XCURSOR_SIZE,24

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us,ru
    kb_variant =
    kb_model =
    kb_options = grp:toggle
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = no
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 20
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)

    layout = dwindle
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 10
    blur = yes
    blur_size = 3
    blur_passes = 1
    blur_new_optimizations = on

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = yes

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = myBezier, 0.05, 0.9, 0.1, 1.05

    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = borderangle, 1, 8, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = yes # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = off
}

# Example per-device config
# See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
device:epic-mouse-v1 {
    sensitivity = -0.5
}

# Example windowrule v1
# windowrule = float, ^(kitty)$
# Example windowrule v2
# windowrulev2 = float,class:^(kitty)$,title:^(kitty)$
# See https://wiki.hyprland.org/Configuring/Window-Rules/ for more


# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = $mainMod, Q, exec, /usr/bin/alacritty
bind = $mainMod, C, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, V, togglefloating,
#bind = $mainMod  R, exec, /usr/bin/wofi --show drun
bind = $mainMod, P, pseudo, # dwindle
#bind = $mainMod, J, togglesplit, # dwindle

# Move focus with mainMod + arrow keys
bind = $mainMod, H, movefocus, l
bind = $mainMod, L, movefocus, r
bind = $mainMod, K, movefocus, u
bind = $mainMod, J, movefocus, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, F1, workspace, 1
bind = $mainMod, F2, workspace, 2
bind = $mainMod, F3, workspace, 3
bind = $mainMod, F4, workspace, 4
bind = $mainMod, F5, workspace, 5
bind = $mainMod, F6, workspace, 6
bind = $mainMod, F7, workspace, 7
bind = $mainMod, F8, workspace, 8
bind = $mainMod, F9, workspace, 9
bind = $mainMod, F10, workspace, 10
bind = $mainMod, F11, workspace, 11
bind = $mainMod, F12, workspace, 12

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod CTRL, F1, movetoworkspace, 1
bind = $mainMod CTRL, F2, movetoworkspace, 2
bind = $mainMod CTRL, F3, movetoworkspace, 3
bind = $mainMod CTRL, F4, movetoworkspace, 4
bind = $mainMod CTRL, F5, movetoworkspace, 5
bind = $mainMod CTRL, F6, movetoworkspace, 6
bind = $mainMod CTRL, F7, movetoworkspace, 7
bind = $mainMod CTRL, F8, movetoworkspace, 8
bind = $mainMod CTRL, F9, movetoworkspace, 9
bind = $mainMod CTRL, F10, movetoworkspace, 10
bind = $mainMod CTRL, F11, movetoworkspace, 11
bind = $mainMod CTRL, F12, movetoworkspace, 12

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow
    '';
  };

  # wayland.windowManager.hyprland = {
    # enable = true;
    # settings = {

    # };
  # };

  # wayland = {
    # windowManager.hyprland = {
      # enable = true;
#    settings = {
#      decoration = {
#        shadow_offset = "0 5";
#        "col.shadow" = "rgba(00000099)";
#      };
#
#      "$mod" = "SUPER";
#
#      animations = {
#        enabled = true;
#        animation = [
#          "border, 1, 2, smoothIn"
#          "fade, 1, 4, smoothOut"
#          "windows, 1, 3, overshot, popin 80%"
#        ];
#      };
#
#      bezier = [
#        "smoothOut, 0.36, 0, 0.66, -0.56"
#        "smoothIn, 0.25, 1, 0.5, 1"
#        "overshot, 0.4,0.8,0.2,1.2"
#      ];
#
#      input = {
#        kb_layout = "ro";
#        follow_mouse = 1;
#        accel_profile = "flat";
#        touchpad = { scroll_factor = 0.3; };
#      };
#
#      bindm = [
#        # mouse movements
#        "$mod, mouse:272, movewindow"
#        "$mod, mouse:273, resizewindow"
#        "$mod ALT, mouse:272, resizewindow"
#      ];
#    };

    # };
  # };


}

#{ config, lib, ... }:
#
#{
#  wayland.windowManager.hyprland = {
#    enable = true;
#    package = lib.makeOverridable
#      (attrs: config.lib.test.mkStubPackage { name = "hyprland"; }) { };
#    plugins =
#      [ "/path/to/plugin1" (config.lib.test.mkStubPackage { name = "foo"; }) ];
#    settings = {
#      decoration = {
#        shadow_offset = "0 5";
#        "col.shadow" = "rgba(00000099)";
#      };
#
#      "$mod" = "SUPER";
#
#      animations = {
#        enabled = true;
#        animation = [
#          "border, 1, 2, smoothIn"
#          "fade, 1, 4, smoothOut"
#          "windows, 1, 3, overshot, popin 80%"
#        ];
#      };
#
#      bezier = [
#        "smoothOut, 0.36, 0, 0.66, -0.56"
#        "smoothIn, 0.25, 1, 0.5, 1"
#        "overshot, 0.4,0.8,0.2,1.2"
#      ];
#
#      input = {
#        kb_layout = "ro";
#        follow_mouse = 1;
#        accel_profile = "flat";
#        touchpad = { scroll_factor = 0.3; };
#      };
#
#      bindm = [
#        # mouse movements
#        "$mod, mouse:272, movewindow"
#        "$mod, mouse:273, resizewindow"
#        "$mod ALT, mouse:272, resizewindow"
#      ];
#    };
#    extraConfig = ''
#      # window resize
#      bind = $mod, S, submap, resize
#
#      submap = resize
#      binde = , right, resizeactive, 10 0
#      binde = , left, resizeactive, -10 0
#      binde = , up, resizeactive, 0 -10
#      binde = , down, resizeactive, 0 10
#      bind = , escape, submap, reset
#      submap = reset
#    '';
#  };
#
#  nmt.script = ''
#    config=home-files/.config/hypr/hyprland.conf
#    assertFileExists "$config"
#
#    normalizedConfig=$(normalizeStorePaths "$config")
#    assertFileContent "$normalizedConfig" ${./simple-config.conf}
#  '';
#}
