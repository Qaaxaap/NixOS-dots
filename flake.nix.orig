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
<<<<<<< HEAD
    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  }; 

 
  outputs = inputs@{ self, winapps, nixpkgs, home-manager, ... }: {
    nixosConfigurations.Qaaxaap = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs winapps; };
=======
  }; 

 
  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.Qaaxaap = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
>>>>>>> develop
      modules = [
       ./configuration.nix
       ./noctalia.nix
       ./chinese.nix
       ./niri.nix
       ./zsh.nix
       ./home.nix
<<<<<<< HEAD
       ./network.nix
       ./winapps.nix
=======
>>>>>>> develop
       home-manager.nixosModules.home-manager
      ];
    }; 
  };
}
