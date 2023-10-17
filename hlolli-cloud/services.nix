{ pkgs, ... }:
{
  systemd.services.web-ide-search = {
    path = [ pkgs.nodejs ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      User = 1000;
      Group = 1000;
      WorkingDirectory = "/storage/forks/web-ide/search";
      ExecStart = ''
        ${pkgs.nodejs}/bin/node main.js
      '';
    };
  };
}
