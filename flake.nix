{
  description = "A flake for golang binaries";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.go_1_18-darwin-aarch64 = {
    url = "https://go.dev/dl/go1.18.darwin-arm64.tar.gz";
    flake = false;
  };

  inputs.go_1_19-aarch64-darwin = {
    url = "https://go.dev/dl/go1.19.darwin-arm64.tar.gz";
    flake = false;
  };

  inputs.go_1_18-x86_64-linux = {
    url = "https://go.dev/dl/go1.18.linux-amd64.tar.gz";
    flake = false;
  };

  inputs.go_1_19-x86_64-linux = {
    url = "https://go.dev/dl/go1.19.linux-amd64.tar.gz";
    flake = false;
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages = {
          go_1_18 = pkgs.stdenv.mkDerivation {
            pname = "go";
            version = "1.18";
            ## TODO support other systems
            src = builtins.getAttr "go_1_18-${system}" inputs;
            phases = [ "unpackPhase" "installPhase" ];
            installPhase = ''
              cp -r . $out
            '';
          };
          go_1_19 = pkgs.stdenv.mkDerivation {
            pname = "go";
            version = "1.19";
            ## TODO support other systems
            src = builtins.getAttr "go_1_19-${system}" inputs;
            phases = [ "unpackPhase" "installPhase" ];
            installPhase = ''
              cp -r . $out
            '';
          };
        };
        defaultPackage = self.packages.${system}.go_1_19;
        devShell = pkgs.mkShell {
          buildInputs = [ self.packages.${system}.go_1_19 ];
        };
      });
}
