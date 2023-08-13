{ pkgs, config, ... }:
let ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.mutableUsers = false;
  users.users.da = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "audio"
    ] ++ ifTheyExist [
      "minecraft"
      "network"
      "wireshark"
      "i2c"
      "mysql"
      "docker"
      "podman"
      "git"
      "libvirtd"
      "deluge"
    ];

    openssh.authorizedKeys.keys = [ (builtins.readFile ../../../../home/da/ssh.pub) ];
    #passwordFile = config.sops.secrets.da-password.path;
    packages = [ pkgs.home-manager ];
  };

  # sops.secrets.da-password = {
  #   sopsFile = ../../secrets.yaml;
  #   neededForUsers = true;
  # };

  home-manager.users.da = import ../../../../home/da/${config.networking.hostName}.nix;

  services.geoclue2.enable = true;
  security.pam.services = { swaylock = { }; };
}
