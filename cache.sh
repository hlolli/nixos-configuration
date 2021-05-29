#!/usr/bin/env bash

build_cmd='with import <nixpkgs> { }; pkgs.stdenv.mkDerivation { name = "cache-shell"; system = builtins.currentSystem; unpackPhase = "true"; srcs = '
build_cmd+=' (import ./default.nix { inherit pkgs; inherit (pkgs) stdenv config lib; }).environment.systemPackages; installPhase = "mkdir $out; ln -s $srcs/* $out"; }'

nix-build -E "$build_cmd" -o result | cachix push darwin-configuration
