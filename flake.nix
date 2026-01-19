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
    nixosConfigurations.nix-thinkpad = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/nix-thinkpad/configuration.nix
        inputs.home-manager-unstable.nixosModules.default
        stylix.nixosModules.stylix
        {
          home-manager.users.dvardo = import ./hosts/nix-thinkpad/home.nix;
        }
      ];
    };

    # server-test
    nixosConfigurations.nix-server-test = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/nix-server-test/configuration.nix
        inputs.home-manager-stable.nixosModules.default
        {
          home-manager.users.dvardo = import ./hosts/nix-server-test/home.nix;
        }
      ];
    };

    # Game console
    nixosConfigurations.nix-gamestation = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        ./hosts/nix-gamestation/configuration.nix
        # Include Jovian NixOS module
        jovian-nixos.nixosModules.default
        inputs.home-manager-unstable.nixosModules.default
        {
          home-manager.users.dvardo = import ./hosts/nix-gamestation/home.nix;
        }
      ];
    };

  };
}
