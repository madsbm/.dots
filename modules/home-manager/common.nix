{ config, pkgs, ... }:

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
