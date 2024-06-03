# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  pkgs,
  ...
}: {
  users.mutableUsers = false;
  users.users = {
    angus = {
      isNormalUser = true;
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel" "media"];
      shell = pkgs.bash;
      uid = 1000;
    };
  };

}
