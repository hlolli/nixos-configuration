{ inputs, ... }:

let
  inherit (inputs) darwin nixpkgs system slackpr;
  darwinOverlays = [
    (
      import ./overlays.nix {
        inherit nixpkgs system;
      }
    )
  ];

  pkgs = import nixpkgs {
    inherit system;
    config = { allowUnfree = true; };
    overlays = darwinOverlays;
  };
  inherit (pkgs) lib;
  goku = pkgs.callPackage ./goku/goku.nix (pkgs // {inherit (pkgs.darwin.apple_sdk.frameworks) Foundation; clang = pkgs.clang_12; });
  docker = (pkgs.docker.override { buildxSupport = true; });
  # vault_ = pkgs.vault.overrideAttrs (oldAttrs: {
  #   src = pkgs.fetchFromGitHub {
  #     owner = "hashicorp";
  #     repo = "vault";
  #     rev = "v1.7.3";
  #     sha256 = "sha256-BO4xzZrX9eVETQWjBDBfP7TlD7sO+gLgbB330A11KAI=";
  #   };
  #   preBuild = ''
  #     substituteInPlace go/src/github.com/hashicorp/vault/vendor/github.com/shirou/gopsutil/cpu/cpu_darwin_cgo.go \
  #       --replace TARGET_OS_MAC 1
  #   '';
  # });
  slack = (import slackpr { inherit system; config = { allowUnfree = true; }; }).slack;
  emacs = (pkgs.callPackage ../emacs.nix {}).emacs;
  exa = pkgs.exa.overrideAttrs(oldAttrs: {
    buildInputs = [ pkgs.libgit2 ] ++ oldAttrs.buildInputs;
  });

  # signal-desktop = pkgs.callPackage ./signal.nix { inherit lib; };
in {

  imports = [
    ../javascript
  ];

  config = {
    users.nix.configureBuildUsers = true;

    nix = {
      package = pkgs.nixUnstable;
      # buildCores = 8;
      useDaemon = true;
      useSandbox = false;
      trustedUsers = [ "hlodversigurdsson" "root" ];
      binaryCaches = [
        # "https://darwin-configuration.cachix.org/"
        "https://cache.nixos.org/"
      ];
      binaryCachePublicKeys = [
        "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "darwin-configuration.cachix.org-1:ysPLcM9Haaufad13Bc0x+UGj3xZhE9lP8fwp8hjjspU="
      ];
      requireSignedBinaryCaches = false;
      # builders-use-substitutes = true
      # builders = @/etc/nix/machines
      extraOptions = ''
        builders-use-substitutes = true
        builders = @/etc/nix/machines
        extra-platforms = x86_64-darwin aarch64-darwin
        experimental-features = nix-command flakes ca-references
        warn-dirty = false
      '';

      # https://medium.com/@zw3rk/provisioning-a-nixos-server-from-macos-d36055afc4ad
      distributedBuilds = true;

      buildMachines = [ {
        hostName = "vartex-dev";
        sshUser = "hlolli";
        sshKey = "/var/root/.ssh/id_rsa";
        systems = [ "x86_64-linux" ];
        supportedFeatures = [ "kvm" ];
        # mandatoryFeatures = [ "kvm" ];
        maxJobs = 4;
      }];
    };

    environment.systemPackages =
      [ emacs ] ++ ( with pkgs; [
        (docker.override { buildxSupport = true; })
        awscli2
        aws-vault
        chromedriver
        colordiff
        direnv
        exa
        git
        gitflow
        gnupg
        goku
        hcloud
        jq
        meld
        nix-prefetch-github
        nixos-shell
        nodejs
        podman
        postgresql_13
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

    services = {
      autossh.sessions = [ {
        name = "postgres-tunnel";
        user = "root";
      } ];

      emacs = {
        enable = true;
        package = emacs;
      };
      lorri = {
        enable = true;
        logFile = "/var/tmp/lorri.log";
      };
      # nix-daemon = {
      #   enable = true;
      #   logFile = "/var/log/nix-daemon.log";
      # };
    };
    system = {
      stateVersion = 4;
    };
  };

}
