# Basic configuration common to all hosts
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./podman.nix
    ./openvpn.nix
    ./openssh.nix
    ./spotify-connect.nix
    ./sound.nix
    ./jetbrains.nix
    ./boot.nix
    ./firewall.nix
    ./tailscale.nix
    ./usb.nix
    ./hyprland.nix
    ./1password.nix
  ];

  nixpkgs = {
    overlays = [
      outputs.overlays.additions
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };

  system.stateVersion = "23.11";

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  console.keyMap = "uk";
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };
  services.xserver.enable = true;

  programs.kdeconnect.enable = true;

  # Enable keyring
  security = {
    pam.services = {
      login.enableGnomeKeyring = true;
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    nssmdns6 = true;
    publish.enable = true;
    publish.userServices = true;
  };

  xdg.portal.enable = true;
  services.flatpak.enable = true;
  boot.supportedFilesystems = ["ntfs"];

  # Opt out of light-dm by default
  services.xserver.displayManager.lightdm.enable = lib.mkDefault false;
}
