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

  # NixOS's gdm module runs the greeter as its own "gdm-greeter" account
  # with a tmpfs home under /run, not the traditional /var/lib/gdm.
  systemd.tmpfiles.rules = [
    "d /run/gdm/home/gdm-greeter 0700 gdm-greeter gdm -"
    "d /run/gdm/home/gdm-greeter/.config 0700 gdm-greeter gdm -"
    "L+ /run/gdm/home/gdm-greeter/.config/monitors.xml - - - - ${monitorsXml}"
  ];
}
