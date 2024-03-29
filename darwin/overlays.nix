{ nixpkgs, ... }:

let
  buildNodejs = pkgs: (pkgs.callPackage (nixpkgs + "/pkgs/development/web/nodejs/nodejs.nix") {
    icu = pkgs.icu68;
    python = pkgs.python3;
  });

in
self: super: {

  chromedriver = (import
    (self.fetchFromGitHub {
      owner = "hlolli";
      repo = "nixpkgs";
      rev = "951a0aba3161918881e40aad9c1a26468198fbe3";
      sha256 = "sha256-wQ6qilUuz7dZVMo0jMmsQSabEX5Kwc8TUL1cm+LTjz0=";
    })
    { localSystem = "aarch64-darwin"; }).chromedriver;

  csound = (
    (import
      (self.fetchFromGitHub {
        owner = "hlolli";
        repo = "nixpkgs";
        rev = "792b108cca40868b884bda0efcba212dfa4897fa";
        sha256 = "sha256-0K5FMip90X5GmcmvroWSrochCXOJVfGI1BrSLYuEM1Q=";
      })
      { localSystem = "aarch64-darwin"; }).csoundWithPlugins
  );

  sqsmover = self.buildGoModule rec {
    pname = "sqsmover";
    version = "0.0.0";

    src = self.fetchFromGitHub {
      owner = "mercury2269";
      repo = "sqsmover";
      rev = "b06c8b8e1a181705a17539af3d00261c39bb3c83";
      sha256 = "sha256-Br1+iEiAJzyV/MsVxFYZxaLGrCK1voShhvlyvNb1zhk=";
    };

    vendorSha256 = "sha256-xuT8oNY0HcmC39o05RtawHxbc2epj/Cp8yzIVqOrU34=";
    proxyVendor = true;
  };

}
