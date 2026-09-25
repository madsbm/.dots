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

  toLuaValue = v:
    if builtins.isString v then builtins.toJSON v
    else if builtins.isBool v then (if v then "true" else "false")
    else if builtins.isInt v || builtins.isFloat v then toString v
    else if builtins.isList v then "{ ${lib.concatMapStringsSep ", " toLuaValue v} }"
    else throw "my.wms.hyprland.vars: unsupported value type";

  hyprVars = ''
    return {
    ${lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "    ${k} = ${toLuaValue v},") cfg.vars)}
    }
  '';
in
{
  imports = [ inputs.caelestia-shell.homeManagerModules.default ];

  config = lib.mkIf (cfg.flavor == "caelestia") {
    programs.caelestia = {
      enable = true;
      cli.enable = true;
      systemd.enable = false;

      cli.settings.wallpaper.postHook = ''awww img "$WALLPAPER_PATH" --transition-type center'';
    };

    # shell.json is symlinked straight to the tracked file below (not built into
    # the store) so it stays writable: caelestia persists its own runtime state
    # (scheme choice, etc.) back into it, and this way that state is shared and
    # in sync across every host instead of living in a per-host store symlink.
    xdg.configFile."caelestia/shell.json".source =
      config.lib.file.mkOutOfStoreSymlink "/etc/nixos/modules/home-manager/wms/hyprland/flavors/caelestia/config/shell.json";

    xdg.configFile."hypr" = {
      source = "${inputs.caelestia-dots}/hypr";
      recursive = true;
    };

    xdg.configFile."caelestia/hypr-vars.lua".text = hyprVars;

    xdg.configFile."caelestia/hypr-user.lua".text = ''
      ${hyprMonitors}
      ${transparentRules}
      hl.config({
          input = {
              kb_layout  = "${cfg.keyboard.layout}",
              kb_variant = "${cfg.keyboard.variant}",
          },
      })

      hl.on("hyprland.start", function()
          hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
          hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
          ${primaryFocusCmd}
      end)
    '';
  };
}
