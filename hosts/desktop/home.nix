{ config, pkgs, stateVersion, ... }:

let
  portraitHeight = 2048;
  centerY = h: (portraitHeight - h) / 2;
in
{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/options.nix
  ];

  my.monitors = [
    { name = "DP-2"; width = 2560; height = 1440; refresh = 99.946; x = 0; y = 0; scale = 1.25; transform = 1; vendor = "DEL"; product = "DELL P2425D"; serial = "93X00C4"; }
    { name = "DP-3"; width = 2560; height = 1440; refresh = 99.946; x = 1152; y = centerY 1152; scale = 1.25; vendor = "DEL"; product = "DELL P2425D"; serial = "76X00C4"; }
    { name = "DP-1"; width = 1920; height = 1080; refresh = 60.0; x = 3200; y = centerY 1080; scale = 1.0; primary = true; vendor = "MSI"; product = "MSI MAG241C"; serial = "0x000001e0"; }
  ];

  my.wms.hyprland.flavor = "serpantinum";
  my.wms.hyprland.keyboard = { layout = "dk"; variant = "nodeadkeys"; };
  my.wms.hyprland.noHardwareCursors = true;
  my.wms.hyprland.transparentApps = {
    spotify = "0.80 0.65 1.0";
    code = "0.92 0.85 1.0";
  };

  my.programs.zsh.theme = "powerlevel10k";
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