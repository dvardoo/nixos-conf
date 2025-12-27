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

  };

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, home-manager-unstable, home-manager-stable, ... }@inputs: {

    # Laptop
    nixosConfigurations.nix-thinkpad = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/nix-thinkpad/configuration.nix
        inputs.home-manager-unstable.nixosModules.default
        {
          home-manager.users.dvardo = import ./hosts/nix-thinkpad/home.nix;
        }
        #inputs.home-manager.nixosModules.nix-thinkpad
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
        #inputs.home-manager.nixosModules.nix-server-test
      ];
    };

  };
}
