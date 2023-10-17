{ stdenv, config, lib, pkgs, ... }:

{
  systemd.services.nginx.serviceConfig.ReadWritePaths = [ "/var/spool/nginx/logs" ];
  # systemd.services.nginx.wants = [ "acme-a.toplap.berlin" ];

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # security.acme.certs = {
  #   "toplap.berlin".email = "hlolli@gmail.com";
  # };

  services.nginx = {
    enable = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    package = pkgs.nginx.override {
      modules = with pkgs.nginxModules; [ fancyindex ];
    };

    virtualHosts."forum.csound.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://unix:/var/discourse/shared/standalone/nginx.http.sock";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
          proxy_set_header X-Real-IP $remote_addr;
        '';
      };
      locations."/.well-known/acme-challenge/kE_euQlrulYDjw7Zb1Jnk-zDYPSnO9cM4iL9Td6QWzg" = {
        extraConfig = "return 200 kE_euQlrulYDjw7Zb1Jnk-zDYPSnO9cM4iL9Td6QWzg.fkZV4c85KNHytNQmKoSWxW3BfZ-STUYb8lfNqawcVFg;";
      };
    };

    virtualHosts."hlolli.com" = {
      enableACME = true;
      forceSSL = true;
      extraConfig = "return 301 $scheme://www.hlolli.com$request_uri;";
    };

    virtualHosts."www.hlolli.com" = {
      enableACME = true;
      forceSSL = true;
      root = "/storage/forks/hlolli.com/public";
    };

    virtualHosts."web-ide-search-api.csound.com" = {
      enableACME = true;
      forceSSL = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4000";
      };
    };

    virtualHosts."static.hlolli.com" = {
      # enableACME = true;
      # forceSSL = true;
      root = "/var/www/ftp";
      extraConfig = ''
        fancyindex on;
        fancyindex_exact_size off;
        fancyindex_directories_first on;
        fancyindex_default_sort date;
        fancyindex_header "/Nginx-Fancyindex-Theme-dark/header.html";
        fancyindex_footer "/Nginx-Fancyindex-Theme-dark/footer.html";
        fancyindex_ignore "Nginx-Fancyindex-Theme-dark";
      '';
      # locations."/trigger-libcsound-wasm-ci" = {
      #   proxyPass = "http://127.0.0.1:1988/trigger-libcsound-wasm-ci";
      # };
      locations."/" = {
        root = "/storage/static/ftp";
      };
    };

  };
}
