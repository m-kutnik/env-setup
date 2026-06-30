{
  description = "nix config";

  inputs = {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

      home-manager = {
        url = "github:nix-community/home-manager";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nix-darwin = {
        url = "github:nix-darwin/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      flake-parts = {
        url = "github:hercules-ci/flake-parts";
        inputs.nixpkgs-lib.follows = "nixpkgs";
      };

      nix-homebrew.url = "github:zhaofengli/nix-homebrew";

      import-tree.url = "github:vic/import-tree";
    };

    outputs =
        inputs:
        inputs.flake-parts.lib.mkFlake { inherit inputs; } {
          imports = [
            (inputs.import-tree ./nix)
          ];
        };
}
