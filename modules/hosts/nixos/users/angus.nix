{inputs, ...}: {
  flake.modules.nixos.nixos = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      angus
    ];

    # ...

    home-manager.users.angus = {pkgs, ...}: {
      imports = with inputs.self.modules.homeManager; [system-default];
      home.packages = [
        pkgs.polychromatic
      ];
    };
  };
}
