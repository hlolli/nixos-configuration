#!/usr/bin/env bash
set -eu -o pipefail
rm -f ./node-env.nix
node2nix -i node-packages.json -o node-packages.nix -c composition.nix \
         --supplement-input supplement.json \
         --nodejs-14 \
         --include-peer-dependencies \
         --development
