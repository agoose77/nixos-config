{
  description = "Angus' NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs"; # keep nixvim nixpkgs consistent with nixpkgs
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    lanzaboote,
    stylix,
    sops-nix,
    niri-flake,
    ...
  } @ inputs: let
    inherit (self) outputs;

    systems = [
      "x86_64-linux"
    ];
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in {
    nixosModules = import ./modules/nixos;
    homeModules = import ./modules/home-manager;

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
    nixosConfigurations = nixpkgs.lib.mapAttrs (host: modules:
      nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs outputs;};
        modules = modules;
      }) {
      "nixos" = [
        ./hosts/nixos
      ];

      "latitude" = [
        ./hosts/latitude
      ];

      "waldo" = [
        ./hosts/waldo
      ];

      "hass-inspiron" = [
        ./hosts/hass-inspiron
      ];

      "hass" = [
        ./hosts/hass
      ];
    };

    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#angus@nixos'
    homeConfigurations =
      nixpkgs.lib.mapAttrs (ident: modules:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          extraSpecialArgs = {inherit inputs outputs;};
          modules = modules;
        })
      {
        "angus@latitude" = [
          ./home/angus/latitude.nix
        ];

        "angus@waldo" = [
          ./home/angus/waldo.nix
        ];

        "angus@nixos" = [
          ./home/angus/nixos.nix
        ];

        "angus@hass-inspiron" = [
          ./home/angus/hass-inspiron.nix
        ];

        "angus@hass" = [
          ./home/angus/hass.nix
        ];
      };
  };
}
