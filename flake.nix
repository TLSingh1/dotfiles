{
	description = "A modular NixOS configuration";

	inputs = {
		nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		zen-browser = {
			url = "github:youwen5/zen-browser-flake";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		nixCats.url = "github:BirdeeHub/nixCats-nvim";
		hyprland.url = "github:hyprwm/Hyprland";
		fast-cmp = {
			url = "github:yioneko/nvim-cmp/perf";
			flake = false;
		};
		ghostty = {
			url = "github:ghostty-org/ghostty";
		};
		ags = {
			url = "github:aylur/ags";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		astal = {
			url = "github:aylur/astal";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		marble = {
			url = "github:marble-shell/shell/gtk4";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = inputs@{ nixpkgs, home-manager, ... }: {
		nixosConfigurations = {
			my-nixos = nixpkgs.lib.nixosSystem {
				system = "x86_64-linux";
				specialArgs = { inherit inputs; };
				modules = [
					./hosts/my-nixos/configuration.nix
					home-manager.nixosModules.home-manager {
						home-manager.useGlobalPkgs = true;
						home-manager.useUserPackages = true;
						home-manager.extraSpecialArgs = { inherit inputs; };
						home-manager.users.tai = import ./home/tai/home.nix;
					}
				];
			};
		};
	};
}
