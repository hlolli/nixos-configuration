{ config, lib, pkgs, ... }:

{
  config = {
    programs.tmux = {
      enable = true;
      extraConfig = ''
        run-shell ${pkgs.tmuxPlugins.yank}/share/tmux-plugins/yank/yank.tmux
      '';
      keyMode = "emacs";
    };
    environment.systemPackages =
      with pkgs; [
      tmuxinator
    ];
  };
}
