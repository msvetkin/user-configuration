# Some settings from https://pastebin.com/S8m1jnY3
{ config, pkgs, ... }:

{
  services.picom = {
    enable = false;
    settings = {
      # frame-opacity = 0.2;
      # detect-rounded-corners = true;
      # corner-radius = 20;
    };
    shadow = true;

    # For NVIDIA, we can run with the simpler xrender backend,
    # which does not do vsync
    # Note: This may also need ForceFullCompositionPipeline in xorg.conf
    # See: https://github.com/chjj/compton/issues/227
    # backend = if isNvidia then "xrender" else "glx";
    # backend = "glx";

    # settings = {
      # no-fading-openclose = true;
      # invert-color-include = [ "TAG_INVERT@:8c = 1" ];
    # };

    fade = true;
    fadeDelta = 14;
    fadeSteps = [ 0.08 0.08 ];

    inactiveOpacity = 0.95;
    activeOpacity = 1.00;

    # shadow = true;
    # shadowExclude = [
      # "n:e:Notification"
      # "name = 'cpt_frame_xcb_window'" # Zoom screen sharing
      # "class_g ?= 'zoom'" # Zoom screen sharing
    # ];
    # shadowOffsets = [ (-15) (-15) ];
    # shadowOpacity = 0.7;

    opacityRules = [
      "0:_NET_WM_STATE@:32a *= '_NET_WM_STATE_HIDDEN'"
      "100:class_i = 'i3lock'"
      "95:class_g = 'org.wezfurlong.wezterm' && focused"
      "85:class_g = 'org.wezfurlong.wezterm' && !focused"
      "95:class_g = 'Gvim' && !focused"
    ];
  };
}
