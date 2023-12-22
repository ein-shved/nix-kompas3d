{
  description = "Installer and launcher for ASKON Kompas3D Home based on Wine";
  outputs = { self, nixpkgs, flake-utils }:
    let
      packages = flake-utils.lib.eachDefaultSystem (system:
        let
          pkgs = import nixpkgs { inherit system; };
          lib = pkgs.lib;
        in
        {
          packages = rec {
            kompas3d = pkgs.callPackage ./kompas3d.nix { };
            default = kompas3d;
          };
        });
      modules = [{
        nixpkgs.overlays = [
          (final: prev: { kompas3d = prev.callPackage ./kompas3d.nix { }; })
        ];
      }];
    in
    packages // { inherit modules; };
}
