{
  description = "NixOS flake-configuration with Noctalia";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      # inputs.quickshell.follows = "quickshell";
    };
    niri.url = "github:sodiboo/niri-flake";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  }; 

 
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.Qaaxaap = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
       ./configuration.nix
       ./noctalia.nix
       ./chinese.nix
       ./niri.nix
       ./zsh.nix
       ./home.nix
       home-manager.nixosModules.home-manager
      ];
    }; 
  };
}
