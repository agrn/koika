{
  description = "A core language for rule-based hardware design";

  inputs = {
    flake-utils.url = github:numtide/flake-utils;
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
  };

  outputs = { self, flake-utils, nixpkgs, ... } @ inputs:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
        {
          packages.default = pkgs.callPackage ./default.nix { };
        }
    );
}
