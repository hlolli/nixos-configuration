{ config, lib, pkgs, ... }:

{
  users.extraUsers.hlolli = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/hlolli";
    description = "Hlöðver Sigurðsson";
    extraGroups = [ "wheel" "audio" "jackaudio" "video" "networkmanager" "vboxusers" "docker" "adbusers" ];
  };

  location = {
    latitude = 52.4584;
    longitude = 13.438;
  };

  imports = [

    ## audio ##
    ./audio/alsa.nix
    ./audio/jack.nix
    ./audio/libs.nix
    ./audio/music.nix
    ./audio/pulseaudio.nix

    ## development ##
    ./development/android.nix
    ./development/docker.nix
    ./development/jdk.nix
    ./development/python.nix
    ./development/wasm.nix

    ## hardware ##
    # ./hardware/bluetooth.nix

    ## graphics/X11 ##
    ./graphics/applications.nix
    # ./graphics/wine.nix
    # ./graphics/xserver.nix

    ## shells ##
    ./shells/core.nix
    ./shells/fish.nix
    ./shells/tmux.nix
    ./shells/zsh.nix

    ## WM (i3+misc) ##
    ./window-manager

    ## top-level ##
    ./linux-tools.nix
    ./nix-tools.nix
    ./essentials.nix
    ./services.nix
    ./terminals.nix

  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.android_sdk.accept_license = true;
  nixpkgs.config.oraclejdk.accept_license = true;

  hardware.opengl = {
    enable = true;
    driSupport32Bit = true;
    # extraPackages = [ pkgs.linuxPackages.nvidia_x11.bin ];
  };
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "hlolli";
  networking.extraHosts = ''
    127.0.0.1 hlolli.local
  '';

  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  networking.firewall.enable = true;
  programs.gnupg.agent.enable = true;

  # linux trace tool
  programs.bcc.enable = true;

  boot.kernelParams = [ "acpi_enforce_resources=lax acpi_osi='!Windows 2015' acpi_backlight=vendor" ]; # acpi=force

  boot.blacklistedKernelModules = [ "ideapad_laptop" "nouveau" ];
  boot.extraModprobeConfig = ''
    # thinkpad acpi
    options snd slots=snd-hda-intel
    options nvidia-drm modeset=1
  '';
  boot.extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  services.logind.extraConfig = "HandleLidSwitch=ignore";

  time.timeZone = "Europe/Berlin";
}
