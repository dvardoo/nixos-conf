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

  outputs = { self, nixpkgs-unstable, nixpkgs-stable, ... }@inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.nix-thinkpad = nixpkgs-unstable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/nix-thinkpad/configuration.nix
        {
          home-manager.users.dvardo = import ./hosts/nix-thinkpad/home.nix;
        }
        #inputs.home-manager.nixosModules.nix-thinkpad
      ];
    };

    nixosConfigurations.nix-server-test = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/nix-server-test/configuration.nix
        {
          home-manager.users.dvardo = import ./hosts/nix-server-test/home.nix;
        }
        #inputs.home-manager.nixosModules.nix-server-test
      ];
    };

  };
}
