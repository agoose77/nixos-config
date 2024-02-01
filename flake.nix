{
  description = "Your new nix config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
	  # neovim
	  nixvim = {
	    url = "github:nix-community/nixvim";
	    inputs.nixpkgs.follows = "nixpkgs";  # keep nixvim nixpkgs consistent with nixpkgs
	  };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";  # keep home-manager nixpkgs consistent with nixpkgs
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#nixos'
    nixosConfigurations = {
      "nixos" = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = [
        	# > Our main nixos configuration file <
        	./nixos/configuration.nix
  
       	];
      };
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#angus@nixos'
    homeConfigurations = {
      "angus@nixos" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
        extraSpecialArgs = {inherit inputs outputs;};
        modules = [     
        	inputs.nixvim.homeManagerModules.nixvim
        	# > Our main home-manager configuration file <
        	./home-manager/home.nix
     		];
      };
    };
  };
}
