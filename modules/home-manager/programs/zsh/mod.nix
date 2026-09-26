{ config, lib, pkgs, ... }:

let
  cfg = config.my.programs.zsh;
  usingP10k = cfg.theme == "powerlevel10k";
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

      # powerlevel10k isn't a bundled oh-my-zsh theme, so it's sourced as a
      # plugin (after oh-my-zsh.sh) instead of via oh-my-zsh's own theme=.
      plugins = lib.optionals usingP10k [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

      oh-my-zsh = {
        enable = true;
        theme = if usingP10k then "" else cfg.theme;
        plugins = cfg.plugins;
      };
    };
  };
}
