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
              project_app =
                python-self.callPackage ./project_app.nix { src = self; };
              project_pkg =
                python-self.callPackage ./project_pkg.nix { src = self; };
              project_dev = python-self.callPackage ./project_dev_shell.nix { };
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
          golden_python_app = pkgs.python3Packages.project_app;
          golden_python_pkg = pkgs.python3Packages.project_pkg;
        };
        defaultPackage = self.packages.${system}.golden_python_app;

        apps = {
          cli_golden = {
            type = "app";
            program =
              "${self.defaultPackage.${system}}/bin/cli_golden_python.py";
          };
        };

        defaultApp = self.apps.${system}.cli_golden;

        devShell = pkgs.python3Packages.project_dev;
      });
}
