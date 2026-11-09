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
    homeManager.noctalia = {pkgs, ...}: let
      plugins = pkgs.fetchFromGitHub {
        owner = "noctalia-dev";
        repo = "community-plugins";
        rev = "e6453e8f016270aa92e913202d96546683bcd20b";
        sha256 = "sha256-4eXfB3ZFeWHhBJ9v6/XVYhJBXVFj99HZ8oxooQNkUwo=";
      };
    in {
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
      home.file =
        builtins.listToAttrs (map (name: {
          name = ".local/share/noctalia/plugins/${name}/";
          value = {
            source = "${plugins}/${name}/";
            recursive = true;
          };
        }) ["nix-search"])
        // {
          ".local/share/noctalia/plugins/wl-screen-mirror" = {
            source = ../../extern/noctalia-wl-mirror;
            recursive = true;
          };
        };

      home.packages = [
        pkgs.luminance
        pkgs.brightnessctl
        pkgs.wl-mirror
        pkgs.nix-search-tv
      ];
    };
  };
}
