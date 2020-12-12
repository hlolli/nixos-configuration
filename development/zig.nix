{ config, lib, pkgs, ... }:

let
  zig_ = pkgs.zig.override({ llvmPackages = pkgs.llvmPackages_11; });
  zigCanary = zig_.overrideAttrs(oldAttrs: {
   pname = "ziglang";
   src = pkgs.fetchFromGitHub {
     owner = "ziglang";
     repo = "zig";
     rev = "7c93d9aacb5987c3ada52f7f68c6f38594e08612";
     sha256 = "0nl4kzb2jn8lylk5zqx4879zwvn9lpca4mbwi6q7hys52flqznp7";
   };
   doCheck = false;

});

in {
  config.environment.systemPackages = [
    zigCanary
  ];
}
