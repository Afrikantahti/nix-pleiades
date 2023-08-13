{ config, inputs, pkgs, ... }: {
  imports = [
    inputs.paste-da-me.nixosModules.server
  ];

  services = {
    paste-da-me = {
      enable = true;
      package = inputs.paste-da-me.packages.${pkgs.system}.server;
      database.createLocally = true;
      environmentFile = config.sops.secrets.paste-da-me-secrets.path;
      port = 8082;
    };

    nginx.virtualHosts."paste.da.me" = {
      forceSSL = true;
      enableACME = true;
      locations."/".proxyPass =
        "http://localhost:${toString config.services.paste-da-me.port}";
    };
  };

  sops.secrets.paste-da-me-secrets = {
    owner = "paste";
    group = "paste";
    sopsFile = ../secrets.yaml;
  };
}
