{ pkgs, ... }:

{
  name = "Hazy";
  src = pkgs.fetchFromGitHub {
    owner = "Astromations";
    repo = "Hazy";
    rev = "1926d9db3e0313b68ca6e2193c2b278e733ac3c4";
    hash = "sha256-2D8hcPaAqsXv7krzd8n77LqxaQzf2GMCqiDuq1YHLks=";
  };
  overwriteAssets = true;
  additionalCss = ''
    .Root__top-container::before {
      display: none !important;
    }
    .before-scroll-node {
      display: none;
    }
    .main-entityHeader-container.main-entityHeader-withBackgroundImage {
      height: unset;
      padding-top: 5vh;
    }
  '';
}
