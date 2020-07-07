{ config, lib, pkgs, ... }:

let zigCanary = pkgs.zig.overrideAttrs(oldAttrs: {
   src = pkgs.fetchFromGitHub {
     owner = "ziglang";
     repo = pname;
     rev = "67e97a1f0fe661b05234e24a58be15d9b48588f2";
     sha256 = "13dwm2zpscn4n0p5x8ggs9n7mwmq9cgip383i3qqphg7m3pkls6z";
   };
});

in {
  config.environment.systemPackages = with pkgs; [
    zigCanary
  ];
}
