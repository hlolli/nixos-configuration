{ config, lib, pkgs, ... }:
with lib;
{
  config.environment.systemPackages =
    with pkgs;
  [
    clang-tools
    wasmer
    wabt
    lldb_10
    # wapi
  ];
}
