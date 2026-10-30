{inputs, ...}: {
  flake.modules = {
    nixos.noctalia = {pkgs, ...}: {
      imports = [
        inputs.noctalia.nixosModules.default
      ];

      programs.noctalia = {
        enable = true;

        # Enables NetworkManager, Bluetooth, UPower, and a power profile service.
        recommendedServices.enable = true;
      };
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
      programs.noctalia.systemd.enable = true;
    };
    homeManager.noctalia = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      stylix.targets.noctalia.enable = true;
      programs.noctalia = {
        enable = true;
        settings = {
          shell.polkit_agent = true;
          battery.warning_threshold = 10;
        };
      };
    };
  };
}
