{ nixpkgs, nixUnstableFlake, system, ... }:

let buildNodejs = pkgs: (pkgs.callPackage (nixpkgs + "/pkgs/development/web/nodejs/nodejs.nix") {
      icu = pkgs.icu68;
      python = pkgs.python3;
    });

in self: super: {
  # darwin = super.darwin // { xcode = myXcode; xcode_12_5 = myXcode; };

  pandoc = super.writeShellScriptBin "pandoc" "echo true";
  myXcode = (super.callPackages ./xcode.nix { }).xcode_12_5;

  qemu = super.qemu.overrideAttrs(old: {
    patches = [
      (builtins.head old.patches)
      (builtins.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixpkgs/416488360b334083743b08d94f7f76c526db0042/pkgs/applications/virtualization/qemu/9p-darwin.patch";
        sha256 = "sha256:01ahgf10n79yxcx3hgzrk4v299jklv8dpzzdxzpszgcw9q5l92m5";
      })
      (builtins.fetchurl {
        url = "https://gist.githubusercontent.com/stefannilsson/8a083e07f4103af2520e87fdb1f50efc/raw/b0873ad29606032b8b8c35b91cb098d9f1ce6635/qemu-patch-apple-arm64-workaround.patch";
        sha256 = "sha256:0mi9ar0p6p8q2xx80gdf7cphz60cqa2ip4ks2gx76jlkgllwnzfg";
      })
    ];
  });

  nodejs = (buildNodejs super) {
    enableNpm = true;
    sha256 = "sha256-0Pk7mEKvuPI8B4YunNSCJucQRUf3skFdJQ/bdS0bNc8=";
    version = "16.2.0";
  };

  # nodejs = ((buildNodejs super) {
  #   enableNpm = true;
  #   sha256 = "sha256-oKkjD5LB8XV+Y/0cF8waPbY8HX72wboe1JUcwysCCHw=";
  #   version = "16.1.0";
  # }).overrideAttrs(oldAttrs: {
  #   postInstall = ''
  #     rm $out/lib/node_modules/npm/bin/node-gyp-bin/node-gyp
  #     ln -s ${prev.nodePackages.node-gyp}/bin/node-gyp \
  #       $out/lib/node_modules/npm/bin/node-gyp-bin/node-gyp
  #   '';
  # });


  nixUnstable = super.nixUnstable.overrideAttrs (o: {
    src = nixUnstableFlake;
    doInstallCheck = false;
    doCheck = false;
    patchPhase = "true";
    buildInputs = o.buildInputs ++ [
      super.nlohmann_json
    ];
  });

  nix = super.nixUnstable.overrideAttrs (o: {
    src = nixUnstableFlake;
    doCheck = false;
    doInstallCheck = false;
    patchPhase = "true";
    buildInputs = o.buildInputs ++ [
      super.nlohmann_json
    ];
  });
}
