{ inputs, ... }:

let
  inherit (inputs) darwin nixpkgs;
  darwinOverlays = [
    (
      import ./overlays.nix {
        inherit nixpkgs;
      }
    )
    # (final: prev: {
    #   emacsng = emacs-ng.packages.x86_64-darwin.emacsng;
    # })
  ];

  pkgs = import nixpkgs {
    # currentSystem = "aarch64-darwin";
    system = "aarch64-darwin";
    # localSystem = "aarch64-darwin";
    config = {
      allowUnfree = true;
      # currentSystem = "aarch64-darwin";
      # localSystem = "aarch64-darwin";

    };
    overlays = darwinOverlays;
  };
  inherit (pkgs) lib;
  goku = pkgs.callPackage ./goku/goku.nix (pkgs // { inherit (pkgs.darwin.apple_sdk.frameworks) Foundation; clang = pkgs.clang_12; });
  docker = (pkgs.docker.override { buildxSupport = true; });
  emacs_ = (pkgs.callPackage ../my-packages/emacs.nix { }).emacs;
  exa = pkgs.exa.overrideAttrs (oldAttrs: {
    buildInputs = [ pkgs.libgit2 ] ++ oldAttrs.buildInputs;
  });

in
{

  imports = [ ];

  config = {

    nix = {
      configureBuildUsers = true;

      settings = {
        cores = 8;
        sandbox = false;
        require-sigs = false;
        trusted-users = [ "hlolli" "root" ];
        substituters = [
          "https://cache.nixos.org/"
          "https://emacsng.cachix.org"
        ];

        trusted-public-keys = [
          "hydra.nixos.org-1:CNHJZBh9K4tP3EKF6FkkgeVYsS3ohTl+oS0Qa8bezVs="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
          "darwin-configuration.cachix.org-1:ysPLcM9Haaufad13Bc0x+UGj3xZhE9lP8fwp8hjjspU="
          "emacsng.cachix.org-1:i7wOr4YpdRpWWtShI8bT6V7lOTnPeI7Ho6HaZegFWMI="
        ];
      };

      useDaemon = true;

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

      buildMachines = [{
        hostName = "vartex-dev";
        sshUser = "root";
        sshKey = "/Users/hlolli/.ssh/id_vartex_dev";
        systems = [ "x86_64-linux" ];
        supportedFeatures = [ "kvm" ];
        # mandatoryFeatures = [ "kvm" ];
        maxJobs = 12;
      }];
    };

    environment.systemPackages = with pkgs; [
      # (docker.override { buildxSupport = true; })
      awscli2
      aws-vault
      bat
      # chromedriver
      colordiff
      csound
      cmake
      # deno
      direnv
      dos2unix
      emacs_
      # erlang
      rebar3
      eza
      fd
      gh
      git
      gitflow
      gnupg
      goku
      hcloud
      jq
      libredwg
      meld
      neovim
      nix-prefetch-github
      nixos-shell
      nixpkgs-fmt
      nodejs-18_x
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
      unzip
      wdiff
      # vault_
      vim
      vscodium
      (yarn.override { nodejs = nodejs-18_x; })
      qemu
      # watchman
      wget

      # csound-dev
      # pkgs.darwin.Libsystem
      # clang.cc
      bison
      boost
      lldb
      flex
      gettext
      gtest
      libsndfile.out
      ninja
      portaudio
    ];

    environment.variables = {
      GOKU = "${goku}";
      GOKU_EDN_CONFIG_FILE = "${./keybindings.edn}";
      ARCHFLAGS = "-arch arm64";
      SHELL = "${pkgs.fish}/bin/fish";
      EDITOR = "${pkgs.neovim}/bin/nvim";
      ERL_AFLAGS = "-kernel shell_history enabled";
    };

    fonts = {
      fontDir = {
        enable = true;
      };
      fonts = with pkgs; [
        fira
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
          set NIX_PATH nixpkgs=https://github.com/NixOS/nixpkgs/archive/89a353ccd2a6b5c78d5ac3789e8c9bc2109a75ec.tar.gz $NIX_PATH
        '';
        interactiveShellInit = ''
          function __fish_command_not_found_handler --on-event fish_command_not_found
            ${pkgs.bash}/bin/bash ${pkgs.nix-index}/etc/profile.d/command-not-found.sh $argv
          end
          # function ll
          #   {exa}/bin/exa --all --long --header --grid $argv
          # end
          function cat
            ${pkgs.bat}/bin/bat --paging=never $argv
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

    nixpkgs.hostPlatform = "aarch64-darwin";
  };

}
