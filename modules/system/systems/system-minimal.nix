{inputs, ...}: {
  # default settings needed for all nixosConfigurations

  flake.modules.nixos.system-minimal = {pkgs, ...}: {
    nixpkgs.config.allowUnfree = true;
    system.stateVersion = "23.11";

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

    imports = with inputs.self.modules.nixos; [
      avahi
      docker
      podman
      flatpak
      locale
      tailscale
      quiet-boot
      openssh
      usb
    ];
  };
}
