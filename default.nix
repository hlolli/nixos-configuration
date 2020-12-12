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
    ./development/javascript.nix
    ./development/jdk.nix
    ./development/python.nix
    ./development/wasm.nix
    ./development/zig.nix

    ## hardware ##
    # ./hardware/bluetooth.nix

    ## graphics/X11 ##
    ./graphics/applications.nix
    ./graphics/nvidia.nix
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
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = [
      pkgs.linuxPackages.nvidia_x11.bin
      pkgs.libGL_driver
      pkgs.linuxPackages.nvidia_x11.out
      pkgs.vaapiIntel
      pkgs.vaapiVdpau
      pkgs.libvdpau-va-gl
    ];
  };
  hardware.enableRedistributableFirmware = true;

  networking.hostName = "hlolli";
  networking.extraHosts = ''
    127.0.0.1 localhost
    127.0.0.1 hlolli.local
  '';

  networking.networkmanager.enable = true;
  networking.nameservers = [ "8.8.8.8" "8.8.4.4" ];
  networking.firewall.enable = true;
  programs.gnupg.agent.enable = true;

  # linux trace tool
  programs.bcc.enable = true;

  boot = {
    extraModulePackages = [ pkgs.linuxPackages.v4l2loopback ];

    extraModprobeConfig = ''
      # thinkpad acpi
      # options snd slots=snd-hda-intel
      # options nvidia-drm modeset=1
      # options snd-hda-intel id=NVidia index=1

      options snd_hda_intel id=PCH,NVidia index=1,2 model=alc233-eapd
      options snd_hda_intel enable=1,0
      options snd-usb-audio index=0
    '';

    blacklistedKernelModules = [ "ideapad_laptop" ];

    kernelParams = [
      "acpi_enforce_resources=lax acpi_osi='!Windows 2015' acpi_backlight=vendor"
    ];

    # initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

    kernel.sysctl = {
      "kernel.nmi_watchdog" = 0;
      "fs.inotify.max_user_watches" = 524288;
      "vm.dirty_writeback_centisecs" = 1500;
    };
  };

  services.logind.extraConfig = "HandleLidSwitch=ignore";

  security.hideProcessInformation = false;

  time.timeZone = "Europe/Berlin";
}
