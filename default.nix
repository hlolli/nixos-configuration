{ config, pkgs, ... }:

let myEmacs = (pkgs.callPackage ./emacs.nix {}).emacs;

in {

  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.goku
      pkgs.slack
      pkgs.git
      pkgs.nodejs
      pkgs.yarn
      pkgs.direnv
      myEmacs
      # pkgs.yabai
      # pkgs.iterm2
    ];

  environment.variables.SHELL = "${pkgs.fish}/bin/fish";

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

  programs.fish.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

}
