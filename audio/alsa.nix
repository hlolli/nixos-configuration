{ config, lib, pkgs, ... }:
with lib;
{
  config = {
    sound = {
      enable = true;
      extraConfig = ''
        # set the default card
        defaults.pcm.!card "USB"
        defaults.ctl.!card "USB"

        # https://github.com/NixOS/nixpkgs/issues/6860#issuecomment-615902599
        pcm_type.jack {
          lib "${pkgs.alsaPlugins}/lib/alsa-lib/libasound_module_pcm_jack.so"
        }
      '';
    };
    environment.systemPackages = with pkgs;
      [
        alsaOss
        alsaPlugins
        alsaTools
        alsaUtils
        alsa-firmware
      ];
    };
}
