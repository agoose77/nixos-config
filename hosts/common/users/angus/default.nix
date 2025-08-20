# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  pkgs,
  config,
  ...
}: {
  users.users. angus = {
    isNormalUser = true;
    # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
    extraGroups = ["networkmanager" "wheel" "media" "docker" "dialout"];
    shell = pkgs.bash;
    uid = 1000;
    hashedPasswordFile = config.sops.secrets.angus-password.path;
  };

  sops.secrets.angus-password = {
    sopsFile = ../../secrets.yaml;
    neededForUsers = true;
  };

  # Choose group ID for media
  users.groups.media.gid = 501;
}
