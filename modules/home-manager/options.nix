{ lib, pkgs, ... }:

{
  options.my = {
    programs = {
      waybar = {
        enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable waybar."; };
        theme = lib.mkOption { type = lib.types.enum [ "mecha" ]; default = "mecha"; description = "Waybar theme to use."; };
      };

      rofi = {
        enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable rofi."; };
        theme = lib.mkOption { type = lib.types.enum [ "default" ]; default = "default"; description = "Rofi theme to use."; };
      };

      swaync = {
        enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable SwayNC (notification daemon)."; };
        theme = lib.mkOption { type = lib.types.enum [ "default" ]; default = "default"; description = "SwayNC theme to use."; };
      };

      kitty = {
        enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable the kitty terminal."; };
        theme = lib.mkOption {
          type = lib.types.enum [ "Catppuccin-Mocha" "Catppuccin-Macchiato" "Catppuccin-Frappe" "Catppuccin-Latte" ];
          default = "Catppuccin-Mocha";
          description = "Kitty color theme, from the bundled kitty-themes collection.";
        };
      };

      zsh = {
        enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable zsh with Oh My Zsh."; };
        theme = lib.mkOption { type = lib.types.str; default = "robbyrussell"; description = "Oh My Zsh theme to use."; };
        plugins = lib.mkOption {
          type = lib.types.listOf lib.types.str;
          default = [ "git" "sudo" "docker" "kubectl" "fzf" ];
          description = "Oh My Zsh plugins to enable.";
        };
      };

      spicetify = {
        enable = lib.mkOption { type = lib.types.bool; default = true; description = "Enable Spicetify (themed Spotify)."; };
        theme = lib.mkOption { type = lib.types.enum [ "hazy" "dribbblish" "text" ]; default = "hazy"; description = "Spicetify theme to use."; };
        marketplace = lib.mkOption { type = lib.types.bool; default = false; description = "Install the Spicetify Marketplace custom app."; };
        extensions = lib.mkOption {
          type = lib.types.listOf (lib.types.enum [
            "playingSource"
            "lastfm"
            "adblock"
            "hidePodcasts"
            "betterGenres"
            "history"
            "shuffle"
            "trashbin"
          ]);
          default = [
            "playingSource"
            "lastfm"
            "adblock"
            "betterGenres"
            "history"
            "shuffle"
          ];
          description = "Spicetify extensions to enable.";
        };
      };
    };

    wms = {
      niri = {
        theme = lib.mkOption { type = lib.types.enum [ "default" ]; default = "default"; description = "Niri config theme to use."; };
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = with pkgs; [ fuzzel ];
          description = "Packages to install alongside niri (launcher, etc.); kitty comes from my.programs.kitty.";
        };
      };

      hyprland = {
        flavor = lib.mkOption { type = lib.types.enum [ "caelestia" "serpantinum" ]; default = "caelestia"; description = "Hyprland flavor/shell to use."; };
        keyboard = {
          layout = lib.mkOption { type = lib.types.str; default = "us"; description = "XKB keyboard layout for Hyprland."; };
          variant = lib.mkOption { type = lib.types.str; default = ""; description = "XKB keyboard variant for Hyprland."; };
        };
        vars = lib.mkOption {
          type = lib.types.attrsOf lib.types.anything;
          default = { };
          description = "Overrides for Caelestia's hypr/variables.lua (keybinds, cursor, gaps, etc.), written to hypr-vars.lua.";
        };
        noHardwareCursors = lib.mkOption {
          type = lib.types.bool;
          default = false;
          description = ''
            Disable Hyprland's hardware cursor planes (cursor.no_hardware_cursors),
            falling back to a software-rendered cursor. Works around an NVIDIA
            KMS driver bug where rapid hardware-cursor-plane imports (e.g. moving
            the mouse across monitors with different scales) can fail to map GPU
            memory (nvidia-drm "Failed to map NvKmsKapiMemory") and crash the
            compositor with an Xid 31 MMU fault.
          '';
        };
        transparentApps = lib.mkOption {
          type = lib.types.attrsOf lib.types.str;
          default = { };
          description = ''
            Per-window-class opacity, applied via a windowrule (plus the
            already-enabled global blur behind it). Compositor-level, so it
            applies no matter which matugen colorscheme or app theme (VS
            Code theme, Spicetify skin) is active.

            Keys are window classes (find one with `hyprctl clients`);
            values are the windowrule opacity string: "<active> <inactive>
            [<fullscreen>]", e.g. { spotify = "0.80 0.65 1.0"; }.
          '';
        };
        packages = lib.mkOption {
          type = lib.types.listOf lib.types.package;
          default = with pkgs; [
            foot
            thunar
            pwvucontrol

            libnotify
            swappy
            dart-sass
            gpu-screen-recorder
            fuzzel
            gammastep
            trash-cli
            bluez
          ];
          description = "Packages to install alongside Hyprland (terminal, launcher, etc.).";
        };
      };
    };

    monitors = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption { type = lib.types.str; };
          width = lib.mkOption { type = lib.types.int; };
          height = lib.mkOption { type = lib.types.int; };
          refresh = lib.mkOption { type = lib.types.float; };
          x = lib.mkOption { type = lib.types.int; };
          y = lib.mkOption { type = lib.types.int; };
          scale = lib.mkOption { type = lib.types.float; default = 1.0; };
          primary = lib.mkOption { type = lib.types.bool; default = false; };
          transform = lib.mkOption {
            type = lib.types.nullOr (lib.types.ints.between 0 7);
            default = null;
            description = ''
              wl_output transform: 0 = normal, 1 = 90°, 2 = 180°, 3 = 270° (clockwise),
              4-7 = the same flipped. Use 1 or 3 for a portrait-mounted monitor;
              null leaves the monitor unrotated.
            '';
          };
        };
      });
      default = [ ];
      description = "Monitor topology";
    };
  };
}
