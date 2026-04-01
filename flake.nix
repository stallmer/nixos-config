{
  description = "Hyprland on NixOS";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Configuration for Thinkpad X1 Gen11
  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixnuc= nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.stephen = import ./home.nix;
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
