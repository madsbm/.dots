{ config, lib, pkgs, username, ... }:

let
  mkMonitorsXml = import ../../lib/gdm-monitors-xml.nix { inherit lib; };

  # GDM's own Mutter greeter needs each output's EDID vendor/product/serial
  # to match it to a physical monitor; only those with all three set here
  # get a <logicalmonitor> entry.
  monitors = builtins.filter
    (m: m.vendor != null && m.product != null && m.serial != null)
    config.home-manager.users."${username}".my.monitors;

  monitorsXml = pkgs.writeText "gdm-monitors.xml" (mkMonitorsXml monitors);
in
{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;

  # Mutter's system-wide config store, checked when there's no per-user
  # override - i.e. exactly the pre-login greeter's situation.
  environment.etc."xdg/monitors.xml".source = monitorsXml;
}
