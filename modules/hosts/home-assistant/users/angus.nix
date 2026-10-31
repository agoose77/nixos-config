{self, ...}: {
  flake.modules.nixos.home-assistant = {config, ...}: {
    imports = with self.modules.nixos; [
      angus
    ];

    # ...

    home-manager.users.angus = {pkgs, ...}: {
      imports = with self.modules.homeManager; [
       system-minimal
      ];
      home.packages = [
      ];
    };
  };
}
