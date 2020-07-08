{ config, lib, pkgs, ... }:

let interactiveShellInit = ''
  function ll
    ${pkgs.exa}/bin/exa --all --long --header --grid $argv
  end
'';

in {
  config = {
    programs.fish = {
      inherit interactiveShellInit;
      vendor.functions.enable = false;
      enable = true;
      promptInit = ''
        ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
      '';
    };
  };
}
