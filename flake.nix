{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";  # keep home-manager nixpkgs consistent with nixpkgs
    };

    # # Hyprland
    # hyprland = {
      # url = "github:hyprwm/Hyprland";
      # # Do not keep pkgs in sync (breaks cachix)
      # # inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#nixos'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
            # # Enable cachix
            # # https://wiki.hyprland.org/Nix/Cachix/
        	# {
        		# nix.settings = {
        	    	# substituters = ["https://hyprland.cachix.org"];
        	    	# trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
        	  	# };
       	  	# }
        	# > Our main nixos configuration file <
        	./nixos/configuration.nix
       	];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#angus@nixos'
    homeConfigurations = {
      # FIXME replace with your username@hostname
      "angus@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        # > Our main home-manager configuration file <
        modules = [./home-manager/home.nix];
      };
    };
  };
}
