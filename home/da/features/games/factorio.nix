{ lib, pkgs, ... }: {
  home = {
    packages = [ pkgs.factorio ];
    persistence = {
      "/persist/home/da" = {
        allowOther = true;
        directories = [ ".factorio" ];
      };
    };
  };
}
