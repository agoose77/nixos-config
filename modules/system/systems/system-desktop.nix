{inputs, ...}: {
  # import all essential nix-tools which are used in all modules of a specific class

  flake.modules.nixos.system-default = {
    imports = with inputs.self.modules.nixos; [
      system-minimal
      niri
      home-manager
      sops
      _1password
      spotify-connect
      sound
      stylix
      kdeconnect
    ];
  };

  flake.modules.homeManager.system-default = {
    imports = with inputs.self.modules.homeManager; [
      system-minimal
      niri
      stylix
      kdeconnect
    ];
  };
}
