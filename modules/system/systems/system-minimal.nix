{
  inputs,
  lib,
  ...
}: let
  stateVersion = "23.11";
in {
  # default settings needed for all nixosConfigurations

  flake.modules = {
    nixos.system-minimal = {pkgs, ...}: {
      nixpkgs.config.allowUnfree = true;
      system = {inherit stateVersion;};

      nix.settings = {
        experimental-features = [
          "nix-command"
          "flakes"
          # "allow-import-from-derivation"
        ];

        # Deduplicate and optimize nix store
        auto-optimise-store = true;
      };

      nix.gc = {
        automatic = true;
        dates = "daily";
        # Keep 14d worth of generations
        options = "--delete-older-than 14d";
      };

      nix.extraOptions = ''
        warn-dirty = false
        keep-outputs = true
      '';

      imports = with inputs.self.modules.nixos;
        [
          avahi
          docker
          podman
          locale
          tailscale
          quiet-boot
          openssh
          sops
          home-manager
          auto-upgrade
        ]
        ++ (with inputs.self.modules.generic; [
          pkgs-by-name
        ]);

      # TODO: sort this out
      networking.networkmanager.enable = true;
      # Opt out of light-dm by default
      services.xserver.displayManager.lightdm.enable = lib.mkForce false;
      services.xserver.enable = true;
    };
    homeManager.system-minimal = {config, ...}: {
      imports = with inputs.self.modules.homeManager; [
        git
        cli
        usb
        nixvim
      ];
      programs.home-manager.enable = true;
      home.homeDirectory = "/home/${config.home.username}";
      home = {inherit stateVersion;};
    };
  };
}
