{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.my.programs.zsh;
in
{
  imports = [ inputs.areofyl-fetch.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {
    programs.fetch = {
      enable = true;
      spin = "xy";
    };

    # fastfetch's own config is managed by serpantinum's matugen pipeline, not here.
    home.packages = [ pkgs.fastfetch ];

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

      # Not a bundled oh-my-zsh theme, so sourced as a plugin instead of via theme=.
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
      ];

      oh-my-zsh = {
        enable = true;
        theme = "";
        plugins = cfg.plugins;
      };

      initContent = lib.mkMerge [
        # Must run before instant prompt to reach the real tty.
        (lib.mkOrder 100 ''
          (( COLUMNS >= 80 && LINES >= 20 )) && fastfetch
        '')
        # Instant prompt must run before anything else that might print.
        (lib.mkOrder 200 ''
          if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
            source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
          fi
        '')
        # After the theme itself loads (plugins are sourced at order 900).
        (lib.mkOrder 1300 ''
          [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
        '')
      ];
    };

    home.file.".p10k.zsh".source = ./p10k.zsh;
  };
}
