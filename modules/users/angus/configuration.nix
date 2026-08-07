{self, ...}: let
  username = "angus";
in {
  flake.modules = {
    nixos."${username}" = {
      lib,
      pkgs,
      ...
    }: {
      imports = with self.modules.nixos; [
        (self.factory.autologin username)
        (self.factory.virtualbox username)
      ];
      users.users."${username}" = {
        isNormalUser = true;
        home = "/home/${username}";
        extraGroups = ["networkmanager" "wheel" "media" "docker" "dialout"];
        shell = pkgs.bash;
        uid = 1000;
        # TODO: hashedPasswordFile = config.sops.secrets.angus-password.path;
      };
      programs.bash.enable = true;
      home-manager.users."${username}" = {
        imports = [
          self.modules.homeManager."${username}"
        ];
      };
    };
    homeManager."${username}" = {pkgs, ...}: {
      home.username = "${username}";
    };
  };
}
