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

    # fastfetch's own config (~/.config/fastfetch/config.jsonc) is owned and
    # dynamically re-rendered by serpantinum's matugen pipeline; see
    # modules/home-manager/wms/hyprland/flavors/serpantinum/home.nix.
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

      # powerlevel10k isn't a bundled oh-my-zsh theme, so it's sourced as a
      # plugin (after oh-my-zsh.sh) instead of via oh-my-zsh's own theme=.
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
        # fastfetch runs before instant prompt's preamble entirely, so its
        # output happens on the real tty (colors intact) and isn't flagged
        # as unexpected console output during init. Skipped in small
        # terminals (e.g. VSCode's integrated panel).
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
