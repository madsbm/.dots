{ ... }:

{
  boot.kernelModules = [ "nct6775" ];

  programs.coolercontrol.enable = true;

  systemd.services.coolercontrold.preStart = ''
    [ -e /etc/coolercontrol/config.toml ] \
      || install -Dm644 ${./coolercontrol.default.toml} /etc/coolercontrol/config.toml
  '';
}
