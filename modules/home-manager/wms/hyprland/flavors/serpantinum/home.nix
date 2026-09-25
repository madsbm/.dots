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

  mkTransparentRule = class: ''
    hl.window_rule({
        name    = "transparent-${class}",
        match   = { class = "^${class}$" },
        opacity = "${cfg.transparentOpacity}",
    })
  '';
  transparentRules = lib.concatStrings (map mkTransparentRule cfg.transparentClasses);

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
in
{
  imports = [ inputs.serpantinum.homeManagerModules.default ];

  config = lib.mkIf (cfg.flavor == "serpantinum") {
    programs.serpantinum.enable = true;

    xdg.configFile."hypr" = {
      source = hyprConfig;
      recursive = true;
    };
  };
}
