{ pkgs, ... }:

let jsnixPkgs = import ./package-lock.nix pkgs;
in {
  config = {
    environment.systemPackages = [
      jsnixPkgs.typescript
      jsnixPkgs.prettier
    ];
  };
}
