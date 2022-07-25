{ inputs, ... }:

let
  inherit (inputs) darwin emacs-ng nixpkgs system;
  darwinOverlays = [
    (
      import ./overlays.nix {
        inherit nixpkgs system;
      }
    )
    (final: prev: {
      emacsng = emacs-ng.packages.x86_64-darwin.emacsng;
    })
  ];

  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
    overlays = darwinOverlays;
  };
  inherit (pkgs) lib;
  goku = pkgs.callPackage ./goku/goku.nix (pkgs // {inherit (pkgs.darwin.apple_sdk.frameworks) Foundation; clang = pkgs.clang_12; });
  docker = (pkgs.docker.override { buildxSupport = true; });
  emacs_ = (pkgs.callPackage ../emacs.nix {}).emacs;
  exa = pkgs.exa.overrideAttrs(oldAttrs: {
    buildInputs = [ pkgs.libgit2 ] ++ oldAttrs.buildInputs;
  });

in {

  imports = [
    ../javascript
  ];

  config = {
    users.nix.configureBuildUsers = true;

    nix = {
      # package = pkgs.nixUnstable;
      buildCores = 8;
      useDaemon = true;
      useSandbox = false;
      trustedUsers = [ "hlolli" "root" ];
      binaryCaches = [
        # "https://darwin-configuration.cachix.org/"
        "https://cache.nixos.org/"
        "https://emacsng.cachix.org"
      ];
      binaryCachePublicKeys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "darwin-configuration.cachix.org-1:ysPLcM9Haaufad13Bc0x+UGj3xZhE9lP8fwp8hjjspU="
        "emacsng.cachix.org-1:i7wOr4YpdRpWWtShI8bT6V7lOTnPeI7Ho6HaZegFWMI="
      ];
      requireSignedBinaryCaches = false;

      extraOptions = ''
        builders-use-substitutes = true
        builders = @/etc/nix/machines
        extra-platforms = x86_64-darwin aarch64-darwin
        experimental-features = nix-command flakes
        warn-dirty = false
        system = aarch64-darwin
      '';

      # https://medium.com/@zw3rk/provisioning-a-nixos-server-from-macos-d36055afc4ad
      distributedBuilds = true;

      buildMachines = [ {
        hostName = "vartex-dev";
        sshUser = "root";
        sshKey = "/var/root/.ssh/id_rsa";
        systems = [ "x86_64-linux" ];
        supportedFeatures = [ "kvm" ];
        # mandatoryFeatures = [ "kvm" ];
        maxJobs = 4;
      }];
    };

    environment.systemPackages = with pkgs; [
      # (docker.override { buildxSupport = true; })
      awscli2
      aws-vault
      # chromedriver
      colordiff
      csound
      # deno
      direnv
      emacs_
      exa
      git
      gitflow
      gnupg
      goku
      hcloud
      jq
      meld
      neovim
      nix-prefetch-github
      nixos-shell
      nodejs_latest
      openjdk
      podman
      postgresql_13
      ripgrep
      slack
      sqsmover
      terraform
      terragrunt
      tmux
      tree
      wdiff
      # vault_
      vim
      yarn
      qemu
      # watchman
      wget
    ];

    environment.variables = {
      GOKU = "${goku}";
      GOKU_EDN_CONFIG_FILE = "${./keybindings.edn}";
      ARCHFLAGS="-arch arm64";
      SHELL = "${pkgs.fish}/bin/fish";
      EDITOR = "${pkgs.neovim}/bin/nvim";
    };

    fonts = {
      fontDir = {
        enable = true;
      };
      fonts = with pkgs; [
        kawkab-mono-font
        nerdfonts
      ];
    };

    programs = {
      gnupg = {
        agent.enableSSHSupport = true;
        agent.enable = true;
      };


      fish = {
        enable = true;
        shellInit = ''
          set PATH /nix/var/nix/profiles/system/sw/bin ~/.npm-global/bin /opt/homebrew/bin ~/.yarn/bin $PATH
        '';
        interactiveShellInit = ''
          function ll
            ${exa}/bin/exa --all --long --header --grid $argv
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


    system = {
      stateVersion = 4;
    };
  };

}
