{
  description = "glim - toggle an Elgato Key Light from the command line";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        rec {
          glim = pkgs.callPackage ./default.nix { };
          default = glim;
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              nim
              nimble
              nph
            ];
          };
        }
      );

      overlays.default = final: prev: { glim = final.callPackage ./default.nix { }; };
    };
}
