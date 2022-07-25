{ nixpkgs, system, ... }:

let buildNodejs = pkgs: (pkgs.callPackage (nixpkgs + "/pkgs/development/web/nodejs/nodejs.nix") {
      icu = pkgs.icu68;
      python = pkgs.python3;
    });

in self: super: {
  # darwin = super.darwin // { xcode = myXcode; xcode_12_5 = myXcode; };

  chromedriver = (import (self.fetchFromGitHub {
    owner = "hlolli";
    repo = "nixpkgs";
    rev = "951a0aba3161918881e40aad9c1a26468198fbe3";
    sha256 = "sha256-wQ6qilUuz7dZVMo0jMmsQSabEX5Kwc8TUL1cm+LTjz0=";
  }) { localSystem = "aarch64-darwin"; }).chromedriver;

  csound = (import (self.fetchFromGitHub {
    owner = "hlolli";
    repo = "nixpkgs";
    rev = "3505a56ab8527dae90c438d8020f4461c3ee22c5";
    sha256 = "sha256-1vNlRwKcs7jaHeVlvERP9G80AA7+F5yUBIuLLPizoOo=";
  }) { localSystem = "aarch64-darwin"; }).chromedriver;

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

  # pandoc = super.writeShellScriptBin "pandoc" "echo true";
  # myXcode = (super.callPackages ./xcode.nix { }).xcode_12_5;

  # nodejs = (buildNodejs super) {
  #   enableNpm = true;
  #   sha256 = "sha256-0Pk7mEKvuPI8B4YunNSCJucQRUf3skFdJQ/bdS0bNc8=";
  #   version = "16.2.0";
  # };
  nodejs = super.nodejs-16_x;
  # nixUnstable = super.nixUnstable.overrideAttrs (o: {
  #   doInstallCheck = false;
  #   doCheck = false;
  #   patchPhase = "true";
  #   buildInputs = o.buildInputs ++ [
  #     super.nlohmann_json
  #   ];
  # });

  nix = self.nixUnstable;
  # gcc = super.gcc11;
  # gcc10 = super.gcc11;
}
