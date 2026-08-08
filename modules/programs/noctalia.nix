{inputs, ...}: {
  flake.modules = {
    nixos.noctalia = {pkgs, ...}: {
      stylix.targets.noctalia-shell.enable = true;
      environment.systemPackages = [
        inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
      ];
    };
    home-manager.noctalia = {
      imports = [
        inputs.noctalia.homeModules.default
      ];

      programs.noctalia = {
        enable = true;

        settings = {
        };
      };
    };
  };
}
