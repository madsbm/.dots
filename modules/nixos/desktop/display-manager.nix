{ config, lib, pkgs, username, ... }:

let
  # GDM's own Mutter greeter needs each output's EDID vendor/product/serial
  # to match it to a physical monitor; only those with all three set here
  # get a <logicalmonitor> entry.
  monitors = builtins.filter
    (m: m.vendor != null && m.product != null && m.serial != null)
    config.home-manager.users."${username}".my.monitors;

  # left = 90, upside_down = 180, right = 270 (same as Hyprland's transform).
  rotationName = [ null "left" "upside_down" "right" ];

  mkLogicalMonitor = m: ''
    <logicalmonitor>
      <x>${toString m.x}</x>
      <y>${toString m.y}</y>
      ${lib.optionalString m.primary "<primary>yes</primary>"}
      <scale>${toString m.scale}</scale>
      ${lib.optionalString (m.transform != null && m.transform >= 1 && m.transform <= 3) ''
      <transform>
        <rotation>${builtins.elemAt rotationName m.transform}</rotation>
        <flipped>no</flipped>
      </transform>
      ''}
      <monitor>
        <monitorspec>
          <connector>${m.name}</connector>
          <vendor>${m.vendor}</vendor>
          <product>${m.product}</product>
          <serial>${m.serial}</serial>
        </monitorspec>
        <mode>
          <width>${toString m.width}</width>
          <height>${toString m.height}</height>
          <rate>${toString m.refresh}</rate>
        </mode>
      </monitor>
    </logicalmonitor>
  '';

  monitorsXml = pkgs.writeText "gdm-monitors.xml" ''
    <monitors version="2">
      <configuration>
        <layoutmode>logical</layoutmode>
        ${lib.concatStrings (map mkLogicalMonitor monitors)}
      </configuration>
    </monitors>
  '';
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
