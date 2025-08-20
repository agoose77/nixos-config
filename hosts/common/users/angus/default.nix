# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{pkgs, ...}: {
  # users.mutableUsers = false;
  # Login as angus
  services.getty = {
    autologinUser = "angus";
    autologinOnce = true;
  };

  users.users = {
    angus = {
      isNormalUser = true;
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel" "media" "docker" "dialout"];
      shell = pkgs.bash;
      uid = 1000;

      packages = with pkgs; [
        oils-for-unix
      ];
    };
  };
}
