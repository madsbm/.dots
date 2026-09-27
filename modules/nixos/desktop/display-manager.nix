{ config, lib, pkgs, username, ... }:

let
  mkMonitorsXml = import ../../lib/gdm-monitors-xml.nix { inherit lib; };

  # GDM matches outputs by EDID vendor/product/serial; only fully-specified monitors get an entry.
  monitors = builtins.filter
    (m: m.vendor != null && m.product != null && m.serial != null)
    config.home-manager.users."${username}".my.monitors;

  monitorsXml = pkgs.writeText "gdm-monitors.xml" (mkMonitorsXml monitors);
in
{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  # Mutter's system-wide store, used when there's no per-user override (i.e. the pre-login greeter).
  environment.etc."xdg/monitors.xml".source = monitorsXml;
}
