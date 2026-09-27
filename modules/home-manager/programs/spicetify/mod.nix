{ config, lib, pkgs, inputs, ... }:

let
  cfg = config.my.programs.spicetify;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  theme = import (./. + "/${cfg.theme}") { inherit pkgs spicePkgs; };
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.default ];

  config = lib.mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      theme = theme;
      enabledCustomApps = lib.optional cfg.marketplace spicePkgs.apps.marketplace;
      enabledExtensions = map (name: spicePkgs.extensions.${name}) cfg.extensions;
      alwaysEnableDevTools = true;
    };
  };
}
