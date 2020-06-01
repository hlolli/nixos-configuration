{ config, lib, pkgs, ... }:
with lib; {
    programs = {
      zsh = {
        enable = true;
        autosuggestions.enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;
        ohMyZsh.enable = true;
        ohMyZsh.plugins = [
          "git" "colored-man-pages" "command-not-found" "extract"
        ];
        ohMyZsh.theme = "bureau";
      };
    };
  }
