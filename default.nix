{ config, pkgs, ... }:

let myEmacs = (pkgs.callPackage ./emacs.nix {}).emacs;
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

    signal-desktop = pkgs.callPackage ./signal.nix { };

in {

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      clj2nix
      pkgs.direnv
      pkgs.gnupg
      pkgs.git
      pkgs.nodejs
      signal-desktop
      pkgs.slack
      pkgs.vim
      pkgs.yarn
      myEmacs
      goku
      # pkgs.yabai
      # pkgs.iterm2
    ];

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";
  environment.variables.GOKU_EDN_CONFIG_FILE = "${./keybindings.edn}";

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
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
