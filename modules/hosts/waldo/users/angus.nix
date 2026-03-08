{inputs, ...}: {
  flake.modules.nixos.waldo = {config, ...}: {
    imports = with inputs.self.modules.nixos; [
      angus
    ];

    # ...

    home-manager.users.angus = {
      ###
    };
  };
}
