{ config, pkgs, stateVersion, ... }:

let
  # Physical panel resolutions and per-monitor scale factors.
  dellRes = { w = 2560; h = 1440; };
  dellScale = 1.25;
  msiRes = { w = 1920; h = 1080; };
  msiScale = 1.0;

  # Logical (post-scale) sizes, actually used for layout math below.
  dellLogical = {
    w = builtins.floor (dellRes.w / dellScale);
    h = builtins.floor (dellRes.h / dellScale);
  };
  # DP-2 is rotated 90 degrees (transform = 1), so its logical footprint is
  # the landscape Dell's dimensions with width/height swapped.
  portraitLogical = { w = dellLogical.h; h = dellLogical.w; };
  msiLogical = { w = builtins.floor (msiRes.w / msiScale); h = builtins.floor (msiRes.h / msiScale); };

  # x: monitors placed left to right, flush against each other.
  dp2X = 0;
  dp3X = dp2X + portraitLogical.w;
  dp1X = dp3X + dellLogical.w;

  # y: vertically center a monitor of height `h` against the tallest
  # screen (the portrait one), so all three share one horizontal
  # center-line - the cursor crosses straight across at eye level.
  centerY = h: (portraitLogical.h - h) / 2;
in
{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/options.nix
  ];

  my.monitors = [
    { name = "DP-2"; width = dellRes.w; height = dellRes.h; refresh = 99.95; x = dp2X; y = centerY portraitLogical.h; scale = dellScale; transform = 1; }
    { name = "DP-3"; width = dellRes.w; height = dellRes.h; refresh = 99.95; x = dp3X; y = centerY dellLogical.h; scale = dellScale; }
    { name = "DP-1"; width = msiRes.w; height = msiRes.h; refresh = 60.0; x = dp1X; y = centerY msiLogical.h; scale = msiScale; primary = true; }
  ];

  my.wms.hyprland.flavor = "serpantinum";
  my.wms.hyprland.keyboard = { layout = "dk"; variant = "nodeadkeys"; };

  # user@host, full path, git branch/status - the standard multi-line
  # informative Oh My Zsh theme.
  my.programs.zsh.theme = "af-magic";
  my.wms.hyprland.vars = {
    cursorTheme = "DMZ-White";
    cursorSize = 24;
    kbLauncher = "SUPER + R";
  };

  programs.serpantinum.settings.wallpaperDir = "~/Pictures/wallpapers/images";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "DMZ-White";
    package = pkgs.vanilla-dmz;
    size = 24;
  };

  programs.git.settings.user = {
    name = "Mads";
    email = "madsbechmortensen@hotmail.dk";
  };

  home.stateVersion = stateVersion;
}