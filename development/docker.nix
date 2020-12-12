{ config, lib, pkgs, ... }:
with lib;
{
  config.environment.variables = {
    SSL_CERT_FILE = "/etc/ssl/certs/ca-bundle.crt";
    LIBGUESTFS_PATH = "${pkgs.libguestfs-appliance}";
  };
  config.virtualisation.docker = {
    enable = true;
    enableNvidia = false;
  };

  config.environment.systemPackages =
    with pkgs;
  [
    autossh
    awscli
    cabal-install
    charles
    docker
    docker-compose
    google-cloud-sdk
    kubernetes
    kubernetes-helm
    lazydocker
    minikube
    # nvidia-docker
    libguestfs
    libguestfs-appliance
    pinentry # for gpg deamon
    saneBackends
    s3cmd
    tmate
  ];
}
