{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    # use "nixos", or your hostname as the name of the configuration
    # it's a better practice than "default" shown in the video
    nixosConfigurations.nix-thinkpad = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs; };
      modules = [
        ./hosts/nix-thinkpad/configuration.nix
        {
          home-manager.users.dvardo = import ./hosts/nix-thinkpad/home.nix;
        }
        #inputs.home-manager.nixosModules.nix-thinkpad
      ];
    };

    nixosConfigurations.nix-server-test = nixpkgs.lib.nixosSystem {
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
