{ pkgs, lib, ... }: {
  home.packages = [ pkgs.prismlauncher-qt5 ];

  home.persistence = {
    "/persist/home/da".directories = [ ".local/share/PrismLauncher" ];
  };
}
