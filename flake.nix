{
  description = "Installer and launcher for ASKON Kompas3D Home based on Wine";
  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {inherit system;};
      lib = pkgs.lib;
    in {
      packages = rec {
        kompas3d = pkgs.callPackage ./kompas3d.nix {inherit kActivation;};
        grdcontrol = pkgs.callPackage ./grdcontrol {};
        kActivation = pkgs.callPackage ./kActivation {};
        default = kompas3d;
      };
      formatter = pkgs.alejandra;
    })
    // {
      nixosModules = rec {
        kompas3d = {
          imports = [
            ./grdcontrol/module.nix
            ./module.nix
          ];
          nixpkgs.overlays = [
            (final: prev: rec {
              kompas3d = prev.callPackage ./kompas3d.nix {inherit kActivation;};
              grdcontrol = prev.callPackage ./grdcontrol {};
              kActivation = prev.callPackage ./kActivation {};
            })
          ];
        };
        default = kompas3d;
      };
    };
}
