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
  goku = pkgs.callPackage ./goku/goku.nix (pkgs // {inherit (pkgs.darwin.apple_sdk.frameworks) Foundation;});
  docker = (pkgs.docker.override { buildxSupport = true; });
  vault_ = pkgs.vault.overrideAttrs (oldAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "hashicorp";
      repo = "vault";
      rev = "v1.7.3";
      sha256 = "sha256-BO4xzZrX9eVETQWjBDBfP7TlD7sO+gLgbB330A11KAI=";
    };
    preBuild = ''
      substituteInPlace go/src/github.com/hashicorp/vault/vendor/github.com/shirou/gopsutil/cpu/cpu_darwin_cgo.go \
        --replace TARGET_OS_MAC 1
    '';
  });
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
      # distributedBuilds = true;
      # buildMachines = [ {
      #   hostName = "95.216.170.8";
      #   sshUser = "hlolli-cloud";
      #   sshKey = "/Users/hlodversigurdsson/.ssh/id_rsa.pub";
      #   systems = [ "x86_64-linux" ];
      #   maxJobs = 2;
      # }];
    };

    environment.systemPackages =
      [ emacs ] ++ ( with pkgs; [
        # awscli2
        (docker.override { buildxSupport = true; })
        direnv
        git
        gitflow
        gnupg
        goku
        hcloud
        jq
        nixos-shell
        nodejs
        podman
        slack
        tree
        vault_
        vim
        yarn
        qemu
        watchman
        wget
      ]);

    environment.variables = {
      GOKU = "${goku}";
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
