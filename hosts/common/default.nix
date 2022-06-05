# This file holds config that i use on all hosts
{ lib, config, pkgs, ... }: {
  imports = [
    ./acme.nix
    ./persist.nix
    ./sops.nix
    ./users.nix
  ];

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME = "pt_BR.UTF-8";
    };
  };
  time.timeZone = lib.mkDefault "America/Sao_Paulo";

  environment = {
    # Activate home-manager environment, if not already enabled
    loginShellInit = ''
      [ -d "$HOME/.nix-profile" ] || /nix/var/nix/profiles/per-user/$USER/home-manager/activate &> /dev/null'';

    homeBinInPath = true;
    localBinInPath = true;
    etc."nixos" = {
      target = "nixos";
      source = "/dotfiles";
    };
  };

  boot = {
    # Quieter boot
    plymouth.enable = true;
    loader.timeout = 0;
    kernelParams =
      [ "quiet" "udev.log_priority=3" "vt.global_cursor_default=0" ];
    consoleLogLevel = 0;
    initrd.verbose = false;
  };

  nix = {
    settings = {
      substituters = [
        "https://nix-community.cachix.org"
        "https://misterio.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "misterio.cachix.org-1:cURMcHBuaSihTQ4/rhYmTwbbfWO8AnZEu6w4aNs3iKE="
      ];

      trusted-users = [ "root" "@wheel" ];
      auto-optimise-store = true;
    };
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
      warn-dirty = false
    '';
    gc = {
      automatic = true;
      dates = "weekly";
    };
  };

  services = {
    geoclue2.enable = true;
    pcscd.enable = true;
    openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "no";
    };
    avahi = {
      enable = true;
      nssmdns = true;
      allowPointToPoint = true;
      publish = {
        enable = true;
        domain = true;
        workstation = true;
        userServices = true;
      };
      reflector = true;
      openFirewall = true;
    };
  };

  programs = {
    fuse.userAllowOther = true;
    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
        functions.enable = true;
      };
    };
  };

  system.stateVersion = "22.05";
}
