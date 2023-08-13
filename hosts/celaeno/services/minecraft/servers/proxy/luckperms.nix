{ pkgs, lib, ... }: {
  services.minecraft-servers.servers.proxy = rec {
    extraPostStart = ''
      echo 'lpv import initial.json.gz' > /run/minecraft-server/proxy.stdin
    '';
    extraReload = extraPostStart;

    symlinks = {
      "plugins/LuckPerms.jar" = let build = "1475"; in pkgs.fetchurl rec {
        pname = "LuckPerms";
        version = "5.4.64";
        url = "https://download.luckperms.net/${build}/velocity/${pname}-Velocity-${version}.jar";
        hash = "sha256-8w9lt7Tuq8sPdLzCoSzE/d56bQjTIv1r/iWyMA4MtLk=";
      };
      "plugins/luckperms/initial.json.gz".format = pkgs.formats.gzipJson { };
      "plugins/luckperms/initial.json.gz".value = let
        mkPermissions = lib.mapAttrsToList (key: value: { inherit key value; });
      in {
        groups = {
          owner.nodes = mkPermissions {
            "group.admin" = true;
            "prefix.1000.&5" = true;
            "weight.1000" = true;

            "librelogin.*" = true;
            "luckperms.*" = true;
            "velocity.command.*" = true;
          };
          admin.nodes = mkPermissions {
            "group.default" = true;
            "prefix.900.&6" = true;
            "weight.900" = true;

            "huskchat.command.broadcast" = true;
          };
          default.nodes = mkPermissions {
            "huskchat.command.channel" = true;
            "huskchat.command.msg" = true;
            "huskchat.command.msg.reply" = true;
          };
        };
        users = {
          "3fc76c64-b1b2-4a95-b3cf-" = {
            username = "da";
            nodes = mkPermissions {
              "group.owner" = true;
            };
          };
          "10ffa557-322a-4b6c-9b3e-" = {
            username = "da";
            nodes = mkPermissions {
              "group.admin" = true;
            };
          };
        };
      };
    };

    files = {
      "plugins/luckperms/config.yml".value = {
        server = "proxy";
        storage-method = "mysql";
        data = {
          address = "127.0.0.1";
          database = "minecraft";
          username = "minecraft";
          password = "@DATABASE_PASSWORD@";
          table-prefix = "luckperms_";
        };
        messaging-service = "sql";
      };
    };
  };
}
