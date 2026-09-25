{ lib, config, pkgs, username, stateVersion, ... }:

{
  imports = [
    ./hardware-configuration.nix

    ../../modules/nixos/profiles/desktop.nix

    ../../modules/nixos/hardware/nvidia.nix
  ];

  # my.wm = "niri";

  my.wm = "hyprland";

  boot.loader = {
    grub = {
      enable = true;
      # useOSProber = true;
      efiSupport = true;
      device = "nodev";
    };

    timeout = null;
  };

  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = stateVersion;
}
