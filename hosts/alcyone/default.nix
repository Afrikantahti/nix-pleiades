{
  imports = [
    ./services
    ./hardware-configuration.nix

    ../common/global
    ../common/users/da
    ../common/optional/fail2ban.nix
    ../common/optional/tailscale-exit-node.nix
  ];

  networking = {
    hostName = "alcyone";
    useDHCP = true;
  };
  system.stateVersion = "22.05";
}

