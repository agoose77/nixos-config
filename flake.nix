{
  description = "Angus' NixOS configuration";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # neovim
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs"; # keep nixvim nixpkgs consistent with nixpkgs
    };

    # Home manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lanzaboote
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # lanzaboote
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    stylix,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    nixosModules = import ./modules/nixos;
    homeManagerModules = import ./modules/home-manager;

    # Your custom packages and modifications, exported as overlays
    overlays = import ./overlays {inherit inputs;};

    packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
    formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
    devShells = forAllSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.mkShell {
        packages = with pkgs; [nix pkgs.home-manager git sops ssh-to-age age];
      };
    });
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#nixos'
    nixosConfigurations = let
      mkSystem = modules:
        nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs outputs;};
          modules = modules;
        };
    in {
      "nixos" = mkSystem [
        ./hosts/nixos
      ];

      "latitude" = mkSystem [
        ./hosts/latitude
      ];

      "waldo" = mkSystem [
        ./hosts/waldo
      ];

      "hass-inspiron" = mkSystem [
        ./hosts/hass-inspiron
      ];

      "hass" = mkSystem [
        ./hosts/hass
      ];
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#angus@nixos'
    homeConfigurations = let
      mkHome = modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = modules;
        };
    in {
      "angus@latitude" = mkHome [
        ./home/angus/latitude.nix
      ];

      "angus@waldo" = mkHome [
        ./home/angus/waldo.nix
      ];

      "angus@nixos" = mkHome [
        ./home/angus/nixos.nix
      ];

      "angus@hass-inspiron" = mkHome [
        ./home/angus/hass-inspiron.nix
      ];

      "angus@hass" = mkHome [
        ./home/angus/hass.nix
      ];
    };
  };
}
