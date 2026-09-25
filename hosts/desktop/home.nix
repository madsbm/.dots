{ config, pkgs, stateVersion, ... }:

let
  # DP-2 (portrait) is the tallest screen, logical 1152x2048 (2560x1440 at
  # scale 1.25, rotated). Center the two shorter landscape screens on its
  # height so all three share one horizontal center-line - the cursor
  # crosses straight across at eye level.
  portraitHeight = 2048;
  centerY = h: (portraitHeight - h) / 2;
in
{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/options.nix
  ];

  my.monitors = [
    { name = "DP-2"; width = 2560; height = 1440; refresh = 99.95; x = 0; y = 0; scale = 1.25; transform = 1; }
    { name = "DP-3"; width = 2560; height = 1440; refresh = 99.95; x = 1152; y = centerY 1152; scale = 1.25; }
    { name = "DP-1"; width = 1920; height = 1080; refresh = 60.0; x = 3200; y = centerY 1080; scale = 1.0; primary = true; }
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