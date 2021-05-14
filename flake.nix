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
            pythonPackageOverrides = python-self: python-super:
              let inherit (python-super) buildPythonPackage lib pythonPackages;
              in with python-self; {

                golden_python = buildPythonPackage rec {
                  pname = "golden_python";
                  version = "0.0";
                  src = self;
                  checkInputs = [ pytestCheckHook ];
                  pytestFlagsArray = [ "tests" "-vv" ];
                  propagatedBuildInputs = [ decorator jinja2 pyjson5 toml ];
                };

                cli_golden_python = pythonPackages.buildPythonApplication rec {
                  pname = "cli_golden_python";
                  version = "0.0";
                  src = self;
                  checkInputs = [ pytestCheckHook pyjson5 toml ];
                  pytestFlagsArray = [ "tests" "-vv" ];
                  propagatedBuildInputs = [ decorator jinja2 ];
                  # outputs = [ "bin" "dev" "doc" "out" ];
                  # preInstall = ''
                  #   mkdir -p $outputDoc
                  #   mkdir -p $outputDoc/share/doc/dflkfld
                  #   touch $outputDoc/share/doc/dflkfld/helloworld
                  # '';
                };

                dev = (with pkgs-self;
                  (with python-self;
                    golden_python.overrideAttrs (oldAttrs: rec {
                      nativeBuildInputs = let
                        vscodeExt = vscode-with-extensions.override {
                          vscodeExtensions = with vscode-extensions;
                            [
                              bbenoist.Nix
                              ms-python.python
                              ms-python.vscode-pylance
                            ] ++ vscode-utils.extensionsFromVscodeMarketplace [{
                              name = "emacs-mcx";
                              publisher = "tuttieee";
                              version = "0.31.0";
                              sha256 =
                                "McSWrOSYM3sMtZt48iStiUvfAXURGk16CHKfBHKj5Zk=";
                            }];
                        };
                      in [ cacert hugo emacs-nox nixfmt typora vscodeExt ]
                      ++ oldAttrs.nativeBuildInputs;
                      shellHook = ''
                        export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
                        export PYTHONPATH=$PWD:$PYTHONPATH
                      '';
                    })));

              };

          in {

            python37 = pkgs-super.python37.override (old: {
              packageOverrides = pkgs-super.lib.composeExtensions
                (old.packageOverrides or (_: _: { })) pythonPackageOverrides;
            });
            python38 = pkgs-super.python38.override (old: {
              packageOverrides = pkgs-super.lib.composeExtensions
                (old.packageOverrides or (_: _: { })) pythonPackageOverrides;
            });
            python39 = pkgs-super.python39.override (old: {
              packageOverrides = pkgs-super.lib.composeExtensions
                (old.packageOverrides or (_: _: { })) pythonPackageOverrides;
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
          cli_golden_python = pkgs.python3Packages.cli_golden_python;
          golden_python = pkgs.python3Packages.golden_python;
        };
        defaultPackage = self.packages.${system}.cli_golden_python;
        devShell = pkgs.python3Packages.dev;
      });
}
