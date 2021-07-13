{
  description = "A simple Python flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }:

    let
      forCustomSystems = custom: f: nixpkgs.lib.genAttrs custom (system: f system);
      allSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" "x86_64-darwin" ];
      devSystems = [ "x86_64-linux" "x86_64-darwin" ];
      forAllSystems = forCustomSystems allSystems;
      forDevSystems = forCustomSystems devSystems;

      nixpkgsFor = forAllSystems (system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
          overlays = [ self.overlay ];
        }
      );

      repoName = "golden-python";
      repoVersion = nixpkgsFor.x86_64-linux.golden-python.version;
      repoDescription = "golden-python - A simple Python flake";
    in
    {
      overlay = final: prev:
        let
          inherit (prev.lib) composeExtensions;
          pythonPackageOverrides = python-self: python-super: {
            golden-python-app =
              python-self.callPackage ./derivation-app.nix { src = self; };
            golden-python =
              python-self.callPackage ./derivation.nix { src = self; };
          };
        in
        {
          python37 = prev.python37.override (old: {
            packageOverrides =
              composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
          });
          python38 = prev.python38.override (old: {
            packageOverrides =
              composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
          });
          python39 = prev.python39.override (old: {
            packageOverrides =
              composeExtensions (old.packageOverrides or (_: _: { }))
                pythonPackageOverrides;
          });
          python3 = final.python38;
          golden-python-app = final.python3Packages.golden-python-app;
        };

      devShell = forDevSystems (system:
        let pkgs = nixpkgsFor.${system}; in pkgs.callPackage ./shell.nix { }
      );

      hydraJobs = { };
      packages = forAllSystems (system:
        with nixpkgsFor.${system}; {
          inherit (python3Packages) golden-python golden-python-app;
        });

      defaultPackage = forAllSystems (system:
        self.packages.${system}.golden-python-app);

      apps = forAllSystems (system: {
        golden-python = {
          type = "app";
          program = "${self.packages.${system}.golden-python-app}/bin/cli_golden";
        };
      }
      );

      defaultApp = forAllSystems (system: self.apps.${system}.golden-python);

      templates = {
        golden-python = {
          description = "template - ${repoDescription}";
          path = ./.;
        };
      };

      defaultTemplate = self.templates.golden-python;
    };
}
