# See https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md for setup instructions
{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
  ];
  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.lanzaboote.configurationLimit = lib.mkDefault 5;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];
}
