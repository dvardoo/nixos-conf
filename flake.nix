{
  description = "Nixos config flake";

  inputs = {
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    home-manager-unstable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    home-manager-stable = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager-unstable, home-manager-stable, jovian-nixos, stylix, ... }@inputs: {

    # Laptop
    nixosConfigurations.thinkpad = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/thinkpad/configuration.nix
        inputs.home-manager-unstable.nixosModules.default
        stylix.nixosModules.stylix
        {
          home-manager.users.dvardo = import ./hosts/thinkpad/home.nix;
        }
      ];
    };

    # Workstation
    nixosConfigurations.workstation = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/workstation/configuration.nix
        inputs.home-manager-unstable.nixosModules.default
        stylix.nixosModules.stylix
        {
          home-manager.users.dvardo = import ./hosts/workstation/home.nix;
        }
      ];
    };

    # server-test
    nixosConfigurations.server-test = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/server-test/configuration.nix
        #inputs.home-manager-stable.nixosModules.default
        #{
        #  home-manager.users.dvardo = import ./hosts/server-test/home.nix;
        #}
      ];
    };

    # Game console
    nixosConfigurations.gamestation = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/gamestation/configuration.nix
        # Include Jovian NixOS module
        jovian-nixos.nixosModules.default
        inputs.home-manager-unstable.nixosModules.default
        stylix.nixosModules.stylix
        {
          home-manager.users.dvardo = import ./hosts/gamestation/home.nix;
        }
      ];
    };

  };
}
