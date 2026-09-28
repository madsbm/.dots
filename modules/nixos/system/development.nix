{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    php
    php85Packages.composer
    nodejs_22
    buf

    rustc
    cargo
    rustfmt
    clippy
    rust-analyzer
    gcc

    nixd
    nixfmt

    docker-client
    docker-compose
    kubectl
    kubernetes-helm
    kind

    git
    jq
    redis
  ];
}
