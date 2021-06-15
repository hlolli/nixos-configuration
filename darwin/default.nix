{ lib, inputs, ... }:

let
  inherit (inputs) darwin nixUnstable nixpkgs system slackpr;
  darwinOverlays = [
    (
      import ./overlays.nix {
        inherit nixpkgs system;
        nixUnstableFlake = nixUnstable;
        pkgs_ = pkgs;
      }
    )
  ];

  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
    overlays = darwinOverlays;
  };

  docker = (pkgs.docker.override { buildxSupport = true; });

  slack = (import slackpr { inherit system; config = { allowUnfree = true; }; }).slack;
  emacs = (pkgs.callPackage ../emacs.nix {}).emacs;
  # signal-desktop = pkgs.callPackage ./signal.nix { inherit lib; };
in {
  config = {

    nix = {
      package = pkgs.nixUnstable;
      # buildCores = 8;
      useDaemon = true;
      useSandbox = false;
      trustedUsers = [ "hlodversigurdsson" ];
      binaryCaches = [
        "https://darwin-configuration.cachix.org/"
        "https://cache.nixos.org/"
      ];
      binaryCachePublicKeys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "darwin-configuration.cachix.org-1:ysPLcM9Haaufad13Bc0x+UGj3xZhE9lP8fwp8hjjspU="
      ];
      requireSignedBinaryCaches = true;
      extraOptions = ''
      experimental-features = nix-command flakes ca-references
      extra-platforms = x86_64-darwin x86_64-linux
      allowUnfree = true
    '';

      # https://medium.com/@zw3rk/provisioning-a-nixos-server-from-macos-d36055afc4ad
      distributedBuilds = true;
      buildMachines = [ {
        hostName = "95.216.170.8";
        sshUser = "hlolli-cloud";
        sshKey = "/Users/hlodversigurdsson/.ssh/id_rsa.pub";
        systems = [ "x86_64-linux" ];
        maxJobs = 2;
      }];
    };

    environment.systemPackages =
      [ emacs ] ++ ( with pkgs; [
        (docker.override { buildxSupport = true; })
        direnv
        git
        gitflow
        gnupg
        nixos-shell
        nodejs
        podman
        slack
        vim
        yarn
        qemu
        watchman
        wget
      ]);

    environment.variables = {
      GOKU_EDN_CONFIG_FILE = "${./keybindings.edn}";
      ARCHFLAGS="-arch arm64";
      SHELL = "${pkgs.fish}/bin/fish";
    };

    fonts = {
      enableFontDir = true;
      fonts = with pkgs; [
        kawkab-mono-font
        nerdfonts
      ];
    };

    programs = {

      gnupg = {
        agent.enable = true;
      };


      fish = {
        enable = true;
        shellInit = ''
          set PATH ~/.npm-global/bin /opt/homebrew/bin ~/.yarn/bin $PATH
        '';
        interactiveShellInit = ''
        function ll
          ${pkgs.exa}/bin/exa --all --long --header --grid $argv
        end

        function brew
          arch -arm64 brew $argv
        end
        '';
        promptInit = ''
          ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
        '';
      };
    };

    services = {
      emacs = {
        enable = true;
        package = emacs;
      };
      lorri = {
        enable = true;
        logFile = "/var/tmp/lorri.log";
      };
      nix-daemon = {
        enable = true;
      };
    };
    system = {
      stateVersion = 4;
    };
  };

}
