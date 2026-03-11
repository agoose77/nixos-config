{inputs, ...}: {
  flake.modules.nixos.hass = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      angus
    ];

    # ...

    home-manager.users.angus = {pkgs, ...}: {
      home.packages = [
      ];
    };
  };
}
