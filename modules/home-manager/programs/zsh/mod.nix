{ config, lib, ... }:

let
  cfg = config.my.programs.zsh;
in
{
  config = lib.mkIf cfg.enable {
    programs.zsh = {
      enable = true;

      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        size = 10000;
        save = 10000;
        ignoreDups = true;
        share = true;
      };

      oh-my-zsh = {
        enable = true;
        theme = cfg.theme;
        plugins = cfg.plugins;
      };
    };
  };
}
