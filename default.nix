{ stdenv, config, pkgs, ... }:

let lib = pkgs.lib;
    nodejs = pkgs.nodejs-16_x;
    nodePackages = lib.dontRecurseIntoAttrs (pkgs.callPackage ./node-packages/default.nix {
      inherit nodejs;
    });
    myEmacs = (pkgs.callPackage ./emacs.nix {}).emacs;
    clj2nix = pkgs.callPackage (pkgs.fetchFromGitHub {
      owner = "hlolli";
      repo = "clj2nix";
      rev = "e6d09dd8c5cda68eb0534bd8501f2d5dcd7b2e95";
      sha256 = "0v0q6iglr0lx13j1snzd8mjxids1af1p2h7bkvmsyk2bfp36naqx";
    }) {};
    goku = pkgs.callPackage ./goku/goku.nix {
      graalvm = pkgs.graalvm11-ce;
      inherit (pkgs.darwin.apple_sdk.frameworks) Foundation;
    };

    signal-desktop = pkgs.callPackage ./signal.nix { inherit lib; };

    solc = pkgs.callPackage ./fixes/solc.nix { };

    pkgsWithAwscli2Fix = import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "f00c849d580677d9b49948e2cb2f47ab43a95f30";
      sha256 = "0pz93a67qazgfhj13wyy1giq22s7s2l36505y4dm0li2h0948359";
    }) {};

    mix2nixPr = import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "5e06ef33447aedfb1f355770d8310643c70d8f42";
      sha256 = "1hf2fqb7d5gk15w2ycajc9vph0ihdd2c7aal4hvh9lsm423f1jm2";
    }) {};

    rebar2nixPr = import (pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nixpkgs";
      rev = "91f3dea4feb562d75ff0b0b77c2aa95543a845bf";
      sha256 = "0gjsrqi67hqkj6fcl3j1j06sl42nxinv5k8hcmp1dxbbq73makdq";
    }) {};

    nixUnstableSrc = pkgs.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "b10256af51dfa929e8f916414d6f021dd45f2e1e";
      sha256 = "sha256:1r6d5y17v5v8mmjva82vgybvhg0s8024qns8irwnbnrbb5nxszgd";
    };

in {

  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [(
    self: super: {
      nixUnstable = super.nixUnstable.overrideAttrs (o: {
        src = nixUnstableSrc;
        patchPhase = "true";
        buildInputs = o.buildInputs ++ [ super.nlohmann_json ];
      });
      nix = super.nixUnstable.overrideAttrs (o: {
        src = nixUnstableSrc;
        patchPhase = "true";
        buildInputs = o.buildInputs ++ [ super.nlohmann_json ];
      });
    }
  )];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    with pkgs; [
      # cachix
      clj2nix
      direnv
      git
      gitflow
      gnupg
      nixUnstable
      nodejs
      signal-desktop
      slack
      vim
      watchman
      wget

      myEmacs
      goku
      pkgsWithAwscli2Fix.awscli2
      mix2nixPr.mix2nix
      rebar2nixPr.beamPackages.rebar3-nix
      (yarn.override { inherit nodejs; })
      nodePackages."@crowdin/cli"
      # pkgs.awscli2
      # pkgs.nixops
      # pkgs.nixops-aws
      # pkgs.yabai
      # pkgs.iterm2
    ]; # ++ (builtins.attrValues nodePackages);

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  environment.variables.GOKU_EDN_CONFIG_FILE = "${./keybindings.edn}";

  # Auto upgrade nix package and the daemon service.
  # programs.direnv.enableNixDirenvIntegration = true;

  nix = {
    buildCores = 8;
    useDaemon = true;
    useSandbox = true;
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
      extra-platforms = x86_64-linux
    '';

    # https://medium.com/@zw3rk/provisioning-a-nixos-server-from-macos-d36055afc4ad
    distributedBuilds = true;
    buildMachines = [ {
      hostName = "nix-docker";
      sshUser = "root";
      sshKey = "/etc/nix/docker_rsa";
      systems = [ "x86_64-linux" ];
      maxJobs = 2;
    }];
  };

  services.nix-daemon = {
    enable = true;
  };

  services.lorri = {
    enable = true;
    logFile = "/var/tmp/lorri.log";
  };

  services.emacs = {
    enable = true;
    package = myEmacs;
  };

  homebrew = {
    enable = true;
    brews = [ "mongodb/brew/libmongocrypt" ];
    taps = [ "mongodb/brew" ];
  };

  programs.fish = {
    enable = true;
    shellInit = ''
      set PATH ~/.npm-global/bin $PATH
    '';
    interactiveShellInit = ''
      function ll
        ${pkgs.exa}/bin/exa --all --long --header --grid $argv
      end
    '';
    promptInit = ''
      ${pkgs.any-nix-shell}/bin/any-nix-shell fish --info-right | source
    '';
  };

  programs.gnupg = {
    agent.enable = true;
  };

  imports = [
    ./virtualization.nix
  ];

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
