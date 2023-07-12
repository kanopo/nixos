{
  description = "Kanopo laptop flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, home-manager }:
    let
      system = "x86_64-linux";
      pgks = import nixpkgs {
        inherit system;
	config.allowUnFree = true;
      };
      lib = nixpkgs.lib;
      user = "me";
    in {
      nixosConfigurations = {
        laptop = lib.nixosSystem {
	  inherit system;
	  modules = [
	    ./configuration.nix
	    home-manager.nixosModules.home-manager {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;
	      home-manager.users.${user} = {
	        imports = [
		  ./homeManager/laptop.nix
		];
	      };
	    }
	  ];

	};
      };

    };
}
