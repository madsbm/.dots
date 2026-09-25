{ config, lib, pkgs, ... }:

let
  cfg = config.my.programs.rofi;
  themeDir = ./. + "/${cfg.theme}";
in
{
  config = lib.mkIf cfg.enable {
    programs.rofi = {
      enable = true;

      terminal = "kitty";
      location = "center";
      modes = [
        "drun"
        "run"
        "window"
      ];

      extraConfig = {
        show-icons = true;
        drun-display-format = "{icon} {name}";
        disable-history = false;
        display-drun = " 󰍜 Apps ";
        display-run = "   Run ";
        display-window = "   Window ";

        sidebar-mode = true;
        window-format = "{w} | {c} | {t}";

        cycle = false;
      };

      theme = "~/.config/rofi/theme.rasi";
    };

    xdg.configFile."rofi/theme.rasi".source = themeDir + "/theme.rasi";
  };
}
