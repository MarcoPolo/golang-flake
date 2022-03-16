{
  description = "A flake for golang binaries";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.go_1_18-darwin-aarch64 = {
    url = "https://go.dev/dl/go1.18.darwin-arm64.tar.gz";
    flake = false;
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.go = pkgs.stdenv.mkDerivation {
          pname = "go";
          version = "1.18";
          ## TODO support other systems
          src = inputs.go_1_18-darwin-aarch64;
          phases = [ "unpackPhase" "installPhase" ];
          installPhase = ''
            cp -r . $out
          '';
        };
        defaultPackage = self.packages.${system}.go;
        devShell = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.go ];
        };
      });
}
