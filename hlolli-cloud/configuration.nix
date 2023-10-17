{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/profiles/qemu-guest.nix")
      ./nginx.nix
      ./services.nix
    ];

  config = {

    environment.systemPackages =
      with pkgs; [
        asciidoctor
        aspellDicts.de
        aspellDicts.en
        autoconf
        autogen
        automake
        bc
        bind
        boot
        cifs-utils
        cloc
        cmake
        convmv
        cowsay
        darcs
        dialog
        disnix
        docker
        duplicity
        dysnomia
        emacs
        encfs
        ethtool
        feh
        fortune
        fping
        gcc
        gdb
        git
        gnumake
        gnupg
        gnuplot
        gnutls
        go
        gv
        htop
        iftop
        imagemagick
        inetutils
        iotop
        jq
        libsndfile
        libtool
        lshw
        lsof
        man-pages
        nfs-utils
        nix-prefetch-scripts
        nmap
        nodejs
        ntfs3g
        openssl
        openvpn
        p7zip
        pandoc
        parallel
        patchelf
        pciutils
        pkg-config
        pmutils
        policycoreutils
        pwgen
        redis
        rlwrap
        shellcheck
        smartmontools
        tcpdump
        tcpflow
        tinc_pre
        udevil
        unar
        unzip
        vim
        wavemon
        wget
        yarn
        zip
      ];

    programs = {
      bash.enableCompletion = true;
    };

    fileSystems = {
      "/" = {
        device = "/dev/sda1";
        fsType = "ext4";
      };
      "/storage" =
        {
          device = "/dev/disk/by-id/scsi-0HC_Volume_2802054";
          fsType = "ext4";
        };
    };
    time.timeZone = "Europe/Berlin";
    services = {
      openssh.enable = true;
      fail2ban.enable = true;
    };
    security = {
      sudo = {
        enable = true;
        wheelNeedsPassword = false;
      };

      acme = {
        acceptTerms = true;
        defaults = {
          email = "hlolli@gmail.com";
        };
      };
    };
    virtualisation.docker.enable = true;
    virtualisation.docker.extraOptions = "-g /storage/docker";
    programs.ssh.startAgent = true;
    programs.ssh.extraConfig = ''
      Host *
        StrictHostKeyChecking no
    '';

    nix.settings = {
      max-jobs = lib.mkDefault 2;
      trusted-users = [ "hlolli-cloud" "root" ];
    };
    swapDevices = [ ];

    # Use the GRUB 2 boot loader.
    boot = {
      initrd = {
        availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" ];
        supportedFilesystems = [ "ext4" ];
      };
      kernelParams = [ "boot.shell_on_fail" ];
      kernelModules = [ ];
      extraModulePackages = [ ];

      loader = {
        grub = {
          enable = true;
          device = "/dev/sda";
          storePath = "/nix/store";
        };
      };
    };

    users = {
      extraUsers = {
        root = {
          password = "";
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDlLrOkb6n8oBCkX1uF4P5WZNaWfw0JzvSFwXvUo7vjcabWoGc3FZ6WdHni1za/Z61YxALp9vk5rJsRmEIzcqjqNPUpMyj34YvwkIqdSYJ1uv2Wg4Zh+gblMak8pbVmAlb5v/3LKQz6ltumRZwJ67CJjBXqrYyurmpLx08DiGLLVf/pDfayisKiZ1h+bsbcipWboCfCii7F+G4ivoLKevMkkg3wpvOFqcwxMryq2x4zFxBksaAMDNWvV68AuVEaSYpHHTolIY7+40fk6aS1Z5X8wFmf6XaX8e1LjuVGXY3H4i4NVa/hCrBrrBBT0y6N9MTNoZKNoVx0FRpuGPGUmtrlne41Hbx1X/qUIjhjR6kHPPuGqWzNWC38E2ofIY6o9TQynC9xVt89M5k0nFmcJ2SUZxJoXa1tLG0ImF0mirNRQutV2/nhj6mjrd73OAckFRazHAhkFaYFzAOWdbg8ZGp+k9q2y1JWRfWq2V2ClOLp+iW4DYrzQDVQssM2zTyDLaVBHVUxSb6JPsQnl4jE05uRMGVpQNId6h2DoNN6Z0xdb4j0nYpvDOkDqPU5Y3QAtHbXQs41MB3yfkNFFKtRrcOVJW7Qi+C2DO4U00zuhkmgiiSNdixOKn+dDdc9NZ4OfhOkgqYf8h0cx/nGX+aHcN+mgqMmRpBoFwCMnCtET6GcAw== hlolli@gmail.com"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC42YvLDZnOAgqggsLLpvaQsY9L+9s2E2qQpVb4q/RqYHcumjTL/jDQizcitZuZ9TjCJjsD/hU8XM+nZIi1llH0CLtnpGM1aRmmFze2QCV9gCWObNnpLd2QcelmezP29wSZI6N5ObKfHAIkAI4/yho3XBEha72pMZZitDFFTmhl5fBUulz3TyTt+x7ZSuNNGnvivJByTlGVqv01nE3rhePOqu0hbcZNX5FdazIJ2gUlXnX45bm92S138k06Yk1GWfthiTDOqd7QE7R96GyP34uJDB7l3qK6OaNT/4yZjDb0Iobt/CTLV0a/v3aEL+I1jbd3M/L0yKLoAjmqotbI/aiD hlolli@linux.fritz.box"
          ];
        };
        hlolli-cloud = {
          isNormalUser = true;
          uid = 1000;
          home = "/home/hlolli-cloud";
          description = "Hetzner - Hlöðver Sigurðsson";
          extraGroups = [ "wheel" "audio" "video" "networkmanager" "vboxusers" "docker" "ftp" ];
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC42YvLDZnOAgqggsLLpvaQsY9L+9s2E2qQpVb4q/RqYHcumjTL/jDQizcitZuZ9TjCJjsD/hU8XM+nZIi1llH0CLtnpGM1aRmmFze2QCV9gCWObNnpLd2QcelmezP29wSZI6N5ObKfHAIkAI4/yho3XBEha72pMZZitDFFTmhl5fBUulz3TyTt+x7ZSuNNGnvivJByTlGVqv01nE3rhePOqu0hbcZNX5FdazIJ2gUlXnX45bm92S138k06Yk1GWfthiTDOqd7QE7R96GyP34uJDB7l3qK6OaNT/4yZjDb0Iobt/CTLV0a/v3aEL+I1jbd3M/L0yKLoAjmqotbI/aiD hlolli@linux.fritz.box"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDlLrOkb6n8oBCkX1uF4P5WZNaWfw0JzvSFwXvUo7vjcabWoGc3FZ6WdHni1za/Z61YxALp9vk5rJsRmEIzcqjqNPUpMyj34YvwkIqdSYJ1uv2Wg4Zh+gblMak8pbVmAlb5v/3LKQz6ltumRZwJ67CJjBXqrYyurmpLx08DiGLLVf/pDfayisKiZ1h+bsbcipWboCfCii7F+G4ivoLKevMkkg3wpvOFqcwxMryq2x4zFxBksaAMDNWvV68AuVEaSYpHHTolIY7+40fk6aS1Z5X8wFmf6XaX8e1LjuVGXY3H4i4NVa/hCrBrrBBT0y6N9MTNoZKNoVx0FRpuGPGUmtrlne41Hbx1X/qUIjhjR6kHPPuGqWzNWC38E2ofIY6o9TQynC9xVt89M5k0nFmcJ2SUZxJoXa1tLG0ImF0mirNRQutV2/nhj6mjrd73OAckFRazHAhkFaYFzAOWdbg8ZGp+k9q2y1JWRfWq2V2ClOLp+iW4DYrzQDVQssM2zTyDLaVBHVUxSb6JPsQnl4jE05uRMGVpQNId6h2DoNN6Z0xdb4j0nYpvDOkDqPU5Y3QAtHbXQs41MB3yfkNFFKtRrcOVJW7Qi+C2DO4U00zuhkmgiiSNdixOKn+dDdc9NZ4OfhOkgqYf8h0cx/nGX+aHcN+mgqMmRpBoFwCMnCtET6GcAw== hlolli@gmail.com"
          ];
        };

        hlolli-ftp = {
          isNormalUser = true;
          uid = 1001;
          home = "/storage/static";
          description = "FTP - Hlöðver Sigurðsson";
          extraGroups = [ "ftp" ];
          openssh.authorizedKeys.keys = [
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC42YvLDZnOAgqggsLLpvaQsY9L+9s2E2qQpVb4q/RqYHcumjTL/jDQizcitZuZ9TjCJjsD/hU8XM+nZIi1llH0CLtnpGM1aRmmFze2QCV9gCWObNnpLd2QcelmezP29wSZI6N5ObKfHAIkAI4/yho3XBEha72pMZZitDFFTmhl5fBUulz3TyTt+x7ZSuNNGnvivJByTlGVqv01nE3rhePOqu0hbcZNX5FdazIJ2gUlXnX45bm92S138k06Yk1GWfthiTDOqd7QE7R96GyP34uJDB7l3qK6OaNT/4yZjDb0Iobt/CTLV0a/v3aEL+I1jbd3M/L0yKLoAjmqotbI/aiD hlolli@linux.fritz.box"
            "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCn/ytKEh4lEgvhTX0GT7R4oWg6o0j9deuRm5bLz9VqVYIDpM2r3hZ2dAG/VNMPwZzBBwRv9pP/yyw99KAU1kqlNcWJCnhFx4tyIVI3sWSFJ2t76EFQ7AFol7VkigWb9uIOxcZhen81s0v0PTU/lEugcVweBi6LrEooEzcTol/XFEO/ksL1E8c1VyIs0KWdw7PuXyVyA731AI/lzLmPHSmSASMtg5BqmbLWnsv9ZzhORqtWEX8i4ySMETRO7JVAMvSM1YwXuYgMGzUXMGv/JY/zpyaOBGBHh9KK27xFVnt1rFU47pgcE0CVzHE44HP+DlAjoAXja7x3Can9BNL7UQGogi4q9Im2/MHeEU1gYJBeTCVaSmW88bis2c3TsGQSVq6Zm5c3m1Xb0b3sdd/qD4XdAUlBPc+ShHDw628HNuXLObEehG4WDldBF1Kf3iuFbs9A997Z259pJyAG/dWq+lM3LLFzScjAlDTd3EdSmz6HAuPf1+cKPqNyrP82vp0Xdjax7DUEfbjBHkGsmo5EqFhMJM+TCTh1hrobfGajro3Ri8QNBJl+Vpyko+ABUbhSOdulGhXxKnihej1ysoGGNHXR2YSxjM/1PsoGIW6ZMq/eCA/6uAHw4aIE/9IaotmFNB5PLGynEtxNF1q9VhvxaZvey4UEsO64lIQ9cjbU1LsEJQ== hlolli@gmail.com"
          ];
        };
      };
    };

    system.stateVersion = "23.05";

  };

}
