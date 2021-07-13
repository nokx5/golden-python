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
      repoVersion = nixpkgsFor.x86_64-linux.golden-python-app.version;
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

      hydraJobs = {

        build = forDevSystems (system: nixpkgsFor.${system}.python3Packages.golden-python);
        build-app = forDevSystems (system: nixpkgsFor.${system}.golden-python-app);

        docker = forDevSystems (system:
          with nixpkgsFor.${system}; dockerTools.buildLayeredImage {
            name = "${repoName}-docker-${repoVersion}";
            tag = "latest";
            created = "now";
            contents = [ golden-python-app ];
            config = {
              Cmd = [ "cli_golden" ];
              # Env = [ "CMDLINE=ENABLED" ];
              # ExposedPorts = { "8000" = { }; };
            };
          });

        # deb = forCustomSystems ["x86_64-linux"] (system: 
        #   with nixpkgsFor.x86_64-linux; releaseTools.debBuild {
        #   inherit stdenv;
        #   name = "${repoName}-debian";
        #   diskImage = vmTools.diskImageFuns.debian8x86_64 {};
        #   src = golden-cpp.src;
        #   # buildInputs = [];
        # });

        # rpm = forCustomSystems ["x86_64-linux"] (system: 
        #   with nixpkgsFor.x86_64-linux; releaseTools.rpmBuild {
        #   name = "${repoName}-redhat";
        #   diskImage = vmTools.diskImageFuns.centos7x86_64 {};
        #   src = golden-cpp.src;
        #   # buildInputs = [];
        # });

        # tarball =
        #   nixpkgsFor.${system}.releaseTools.sourceTarball {
        #     name = "${repoName} - tarball";
        #     src = autoconf missing;
        #   };

        # clang-analysis =
        #   nixpkgsFor.${system}.releaseTools.clangAnalysis {
        #     name = "${repoName}-clang-analysis";
        #     src = self;
        #   };

        # coverage =
        #   nixpkgsFor.${system}.releaseTools.coverageAnalysis {
        #     name = "${repoName}-coverage";
        #     src = self.hydraJobs.tarball;
        #     #lcovFilter = [ "*/tests/*" ];
        #   };

        release = forDevSystems (system:
          with nixpkgsFor.${system}; releaseTools.aggregate
            {
              name = "${repoName}-release-${repoVersion}";
              constituents =
                [
                  self.hydraJobs.build.${system}
                  self.hydraJobs.build-app.${system}
                  #self.hydraJobs.docker.${system}
                ] ++ lib.optionals (hostPlatform.isLinux) [
                  #self.hydraJobs.deb.x86_64-linux
                  #self.hydraJobs.rpm.x86_64-linux
                  #self.hydraJobs.coverage.x86_64-linux
                ];
              meta.description = "hydraJobs: ${repoDescription}";
            });


      };
      packages = forAllSystems (system:
        with nixpkgsFor.${system}; {
          inherit (python3Packages) golden-python golden-python-app;
        });

      defaultPackage = forAllSystems (system:
        self.packages.${system}.golden-python-app);

      apps = forAllSystems (system: {
        golden-python-app = {
          type = "app";
          program = "${self.packages.${system}.golden-python-app}/bin/cli_golden";
        };
      }
      );

      defaultApp = forAllSystems (system: self.apps.${system}.golden-python-app);

      templates = {
        golden-python = {
          description = "template - ${repoDescription}";
          path = ./.;
        };
      };

      defaultTemplate = self.templates.golden-python;
    };
}
