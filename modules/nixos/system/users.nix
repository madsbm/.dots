{ username, pkgs, ... }:

{
  programs.zsh.enable = true;

  users.users."${username}" = {
    isNormalUser = true;
    extraGroups = [ "wireshark" "lp" "storage" "audio" "video" "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };
}
