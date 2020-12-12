{ pkgs, lib, config, ... }:

{
  services.xserver.videoDrivers = [ "modesetting" "nouveau" ];
  hardware.nvidia.prime = {
    offload.enable = false;

    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";

    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };
}
