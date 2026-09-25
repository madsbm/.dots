{ config, pkgs, stateVersion, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/options.nix
  ];

  # Left to right on the desk: DP-2 (Dell, portrait) | DP-3 (Dell, landscape,
  # center) | DP-1 (MSI, primary, right). DP-2/DP-3 are identical models
  # (Dell P2425D) so which serial is actually on the left is a guess from the
  # old 2-monitor layout — if the rotated picture lands on the center screen
  # instead of the left one after a rebuild, just swap the two `name` fields.
  # transform = 1 is a guess at rotation direction too: if the portrait
  # screen comes up upside down, change it to 3.
  my.monitors = [
    { name = "DP-2"; width = 2560; height = 1440; refresh = 99.95; x = 0; y = 0; scale = 1.25; transform = 1; }
    { name = "DP-3"; width = 2560; height = 1440; refresh = 99.95; x = 1152; y = 0; scale = 1.25; }
    { name = "DP-1"; width = 1920; height = 1080; refresh = 60.0; x = 3200; y = 0; scale = 1.0; primary = true; }
  ];

  my.wms.hyprland.flavor = "serpantinum";
  my.wms.hyprland.keyboard = { layout = "dk"; variant = "nodeadkeys"; };
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

  # my.programs.spicetify.theme = "text";

  programs.git.settings.user = {
    name = "Mads";
    email = "madsbechmortensen@hotmail.dk";
  };

  home.stateVersion = stateVersion;
}