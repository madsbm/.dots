{ lib, config, pkgs, inputs, ... }:

let
  cfg = config.my.wms.hyprland;

  mkHyprMonitor = m: ''
    hl.monitor({
        output    = "${m.name}",
        mode      = "${toString m.width}x${toString m.height}@${toString m.refresh}",
        position  = "${toString m.x}x${toString m.y}",
        scale     = ${toString m.scale},
        ${lib.optionalString (m.transform != null) "transform = ${toString m.transform},"}
    })
  '';
  hyprMonitors = lib.concatStrings (map mkHyprMonitor config.my.monitors);

  primaryOutputs = builtins.filter (m: m.primary) config.my.monitors;
  primaryFocusCmd = lib.optionalString (primaryOutputs != [ ]) ''
    hl.exec_cmd("hyprctl dispatch focusmonitor ${(builtins.head primaryOutputs).name}")
  '';

  mkTransparentRule = class: opacity: ''
    hl.window_rule({
        name    = "transparent-${class}",
        match   = { class = "^${class}$" },
        opacity = "${opacity}",
    })
  '';
  transparentRules = lib.concatStrings (lib.mapAttrsToList mkTransparentRule cfg.transparentApps);

  hyprlandLua = pkgs.writeText "hyprland.lua" ''
    require("config/variables")
    require("config/env")
    require("config/autostart")
    require("config/monitors")
    require("config/settings")
    require("config/keybinds")
    require("config/user")
  '';

  monitorsLua = pkgs.writeText "monitors.lua" hyprMonitors;

  userLua = pkgs.writeText "user.lua" ''
    hl.config({
        input = {
            kb_layout  = "${cfg.keyboard.layout}",
            kb_variant = "${cfg.keyboard.variant}",
        },
    })

    ${lib.optionalString cfg.noHardwareCursors ''
    hl.config({
        cursor = {
            no_hardware_cursors = true,
        },
    })
    ''}
    ${transparentRules}
    hl.on("hyprland.start", function()
        hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
        hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
        ${primaryFocusCmd}
    end)
  '';

  # ilyamiro/serpantinum ships a fixed require() list with no user-override hook,
  # so we splice in our own hyprland.lua/monitors.lua/config/user.lua on top of
  # their vendored config rather than trying to layer xdg.configFile entries
  # (which would collide with the paths already present in their source tree).
  hyprConfig = pkgs.runCommand "serpantinum-hypr-config" { } ''
    mkdir -p $out/config
    cp -r ${inputs.serpantinum}/compositors/hyprland/config/. $out/config/
    chmod -R u+w $out
    cp ${hyprlandLua} $out/hyprland.lua
    cp ${monitorsLua} $out/config/monitors.lua
    cp ${userLua} $out/config/user.lua
  '';

  # serpantinumd re-renders ~/.config/fastfetch/config.jsonc itself (its own
  # matugen template, baked into the package, colored from the current
  # wallpaper) every time the theme changes - so managing that path
  # ourselves would just get overwritten. Patch the template it ships
  # instead, keeping the {{colors.*}} placeholders for the dynamic theming.
  fastfetchTemplate = pkgs.writeText "fastfetch.jsonc.template" ''
    {
      "$schema": "https://github.com/fastfetch-cli/fastfetch/raw/master/doc/json_schema.json",
      "logo": {
        "type": "builtin",
        "color": {
          "1": "{{colors.primary.default.hex}}",
          "2": "{{colors.tertiary.default.hex}}",
          "3": "{{colors.secondary.default.hex}}"
        },
        "padding": { "top": 1, "left": 2, "right": 3 }
      },
      "display": {
        "separator": "  ",
        "color": { "separator": "{{colors.on_surface.default.hex}}" }
      },
      "modules": [
        "break",
        { "type": "title", "format": "{1}@{2}", "color": { "user": "{{colors.primary.default.hex}}" } },
        "break",
        { "type": "os", "key": "󱄅 os    ", "keyColor": "{{colors.primary.default.hex}}" },
        { "type": "uptime", "key": "󰅐 up    ", "keyColor": "{{colors.tertiary.default.hex}}" },
        { "type": "shell", "key": "󰞷 sh    ", "keyColor": "{{colors.secondary.default.hex}}" },
        { "type": "display", "key": "󰍹 dsp   ", "keyColor": "{{colors.on_surface.default.hex}}" },
        { "type": "wm", "key": " wm    ", "keyColor": "{{colors.inverse_primary.default.hex}}" },
        { "type": "terminal", "key": " term  ", "keyColor": "{{colors.primary.default.hex}}" },
        { "type": "cpu", "key": "󰻠 cpu   ", "keyColor": "{{colors.tertiary.default.hex}}" },
        { "type": "gpu", "key": "󰍛 gpu   ", "keyColor": "{{colors.secondary.default.hex}}" },
        { "type": "memory", "key": "󰘚 ram   ", "keyColor": "{{colors.on_surface.default.hex}}" },
        { "type": "disk", "key": "󰉉 disk  ", "keyColor": "{{colors.inverse_primary.default.hex}}" },
        { "type": "battery", "key": "󰁹 bat   ", "keyColor": "{{colors.primary.default.hex}}" },
        "break",
        { "type": "colors", "symbol": "circle" }
      ]
    }
  '';

  serpantinumPackage = inputs.serpantinum.packages.${pkgs.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cp ${fastfetchTemplate} $out/share/serpantinum/assets/matugen/templates/fastfetch.jsonc.template
    '';
  });
in
{
  imports = [ inputs.serpantinum.homeManagerModules.default ];

  config = lib.mkIf (cfg.flavor == "serpantinum") {
    programs.serpantinum.enable = true;
    programs.serpantinum.package = serpantinumPackage;

    xdg.configFile."hypr" = {
      source = hyprConfig;
      recursive = true;
    };
  };
}
