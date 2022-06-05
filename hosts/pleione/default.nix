# System configuration for my laptop
{ pkgs, inputs, ... }: {
  imports = [
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-amd
    inputs.hardware.nixosModules.common-pc-ssd

    ./hardware-configuration.nix
    ../common
    ../common/modules/misterio-greetd.nix
    ../common/modules/pipewire.nix
    ../common/modules/podman.nix
    ../common/modules/postgres.nix
    ../common/modules/steam.nix

    ./wireguard.nix
  ];


  networking.networkmanager.enable = true;

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_5_18;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernel.sysctl = {
      # LoL fix
      "abi.vsyscall32" = 0;
    };
  };

  services.dbus.packages = [ pkgs.gcr ];

  powerManagement.powertop.enable = true;
  programs = {
    light.enable = true;
    gamemode.enable = true;
    adb.enable = true;
    dconf.enable = true;
    kdeconnect.enable = true;
  };

  # Lid settings
  services.logind ={
    lidSwitch = "suspend";
    lidSwitchExternalPower = "lock";
  };

  xdg.portal = {
    enable = true;
    gtkUsePortal = true;
    wlr.enable = true;
  };

  system.stateVersion = "22.05";
}
