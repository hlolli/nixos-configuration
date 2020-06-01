{ config, lib, pkgs, ... }:
with lib;
let
  clojure = pkgs.clojure.override { jdk11 = pkgs.graalvm8; };
  leiningen = pkgs.leiningen.override { jdk = pkgs.jdk8; };
in
{
  config = {
    environment.variables = {
      JAVA_HOME = "${pkgs.openjdk11.home}";
    };
    environment.systemPackages =
      with pkgs; [
        boot
        clojure
        clj-kondo
        leiningen
        maven
        openjdk
      ];
  };
}
