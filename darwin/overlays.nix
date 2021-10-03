{ nixpkgs, system, ... }:

let buildNodejs = pkgs: (pkgs.callPackage (nixpkgs + "/pkgs/development/web/nodejs/nodejs.nix") {
      icu = pkgs.icu68;
      python = pkgs.python3;
    });

in self: super: {
  # darwin = super.darwin // { xcode = myXcode; xcode_12_5 = myXcode; };

  sqsmover = self.buildGoModule rec {
    pname = "sqsmover";
    version = "0.0.0";

    src = self.fetchFromGitHub {
      owner = "mercury2269";
      repo = "sqsmover";
      rev = "b06c8b8e1a181705a17539af3d00261c39bb3c83";
      sha256 = "sha256-Br1+iEiAJzyV/MsVxFYZxaLGrCK1voShhvlyvNb1zhk=";
    };

    vendorSha256 = "sha256-7VK6oUO0Q90AL4qB8adtejD7ltoWG12vsuvwjj7p8wo=";
    runVend = true;
  };

  pandoc = super.writeShellScriptBin "pandoc" "echo true";
  myXcode = (super.callPackages ./xcode.nix { }).xcode_12_5;

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
