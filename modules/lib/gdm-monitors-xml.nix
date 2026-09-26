{ lib }:

let
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
in

# monitors: my.monitors entries with vendor/product/serial set.
monitors: ''
  <monitors version="2">
    <configuration>
      <layoutmode>logical</layoutmode>
      ${lib.concatStrings (map mkLogicalMonitor monitors)}
    </configuration>
  </monitors>
''
