{
  description = "A simple Python flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, utils }:
    utils.lib.eachSystem [ "x86_64-linux" ] (system:
      let
        overlay = pkgs-self: pkgs-super:
          let
            inherit (pkgs-super.lib) composeExtensions;
            pythonPackageOverrides = python-self: python-super: {
              golden-python-app =
                python-self.callPackage ./derivation-app.nix { src = self; };
              golden-python =
                python-self.callPackage ./derivation.nix { src = self; };
              shell = python-self.callPackage ./shell.nix { };
            };
          in {
            python37 = pkgs-super.python37.override (old: {
              packageOverrides =
                composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
            });
            python38 = pkgs-super.python38.override (old: {
              packageOverrides =
                composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
            });
            python39 = pkgs-super.python39.override (old: {
              packageOverrides =
                composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
            });
            python3 = pkgs-self.python38;
          };

        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
          overlays = [ overlay ];
        };
      in {
        packages = {
          inherit (pkgs.python3Packages) golden-python golden-python-app shell;
        };
        defaultPackage = self.packages.${system}.golden-python-app;

        apps = {
          cli-golden-python = {
            type = "app";
            program = "${self.defaultPackage.${system}}/bin/golden-python";
          };
        };

        defaultApp = self.apps.${system}.cli-golden-python;

        devShell = self.packages.${system}.golden-python-app;
      });
}
