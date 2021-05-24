{ pkgs, nodejs, stdenv }:

let
  super = import ./composition.nix {
    inherit pkgs nodejs;
    inherit (stdenv.hostPlatform) system;
  };
  self = super // {
    "@crowdin/cli" = super."@crowdin/cli".override (old: {
      buildInputs = old.buildInputs ++ [ pkgs.openjdk ];
      nativeBuildInputs = [ pkgs.makeWrapper ];
      bypassCache = false;
      postInstall = ''
        mkdir $out/bin
        ln -s $out/lib/node_modules/@crowdin/cli/jdeploy-bundle/jdeploy.js $out/bin/crowdin
      '';
    });
  };
in self
