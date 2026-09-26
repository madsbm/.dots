{ config, lib, pkgs, ... }:

let
  mkMonitorsXml = import ../lib/gdm-monitors-xml.nix { inherit lib; };
  gdmMonitors = builtins.filter
    (m: m.vendor != null && m.product != null && m.serial != null)
    config.my.monitors;
in
{
  imports = [
    ./theming/default.nix
    ./programs/spicetify/mod.nix
    ./programs/kitty/mod.nix
    ./programs/zsh/mod.nix
  ];

  home.packages = with pkgs; [
    brightnessctl
    fzf
  ];

  # GNOME/Mutter (the GDM greeter) also reads this to lay out the login
  # screen; see modules/nixos/desktop/display-manager.nix.
  home.file.".config/monitors.xml" = lib.mkIf (gdmMonitors != [ ]) {
    text = mkMonitorsXml gdmMonitors;
  };

  services.polkit-gnome.enable = true;
  services.mpris-proxy.enable = true;

  programs.ssh = {
    enable = true;
  };

  programs.git = {
    enable = true;
  };

  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      github.github-vscode-theme
      vscode-icons-team.vscode-icons

      jnoortheen.nix-ide

      redhat.vscode-yaml
      redhat.vscode-xml

      redhat.java
      vue.volar
      rust-lang.rust-analyzer
      ms-python.python
      dart-code.flutter
      prisma.prisma
      tamasfe.even-better-toml
      dart-code.dart-code

      esbenp.prettier-vscode

      anthropic.claude-code
    ];
  };
}
