{ pkgs ? import <nixpkgs> {}, # the two lines are for usual and flakes nix compatibility
project_pkg ? with pkgs; with python3Packages; pkgs.callPackage ./derivation.nix {
  src = ./.;
}, project_app ? with pkgs; callPackage ./derivation_app.nix {
   pythonPackages = python3Packages;
   src = ./.;
} }:

let
  pythonPackages = pkgs.python3Packages;
  vscodeExt = (with pkgs;
    vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          bbenoist.Nix
          eamodio.gitlens
          ms-python.python
          ms-python.vscode-pylance
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [{
          name = "emacs-mcx";
          publisher = "tuttieee";
          version = "0.31.0";
          sha256 = "McSWrOSYM3sMtZt48iStiUvfAXURGk16CHKfBHKj5Zk=";
        }
        {
          name = "restructuredtext";
          publisher = "lextudio";
          version = "135.0.0";
          sha256 = "yjPS9fZ628bfU34DsiUmZkOleRzW6EWY8DUjIU4wp9w=";
        }
        ];
    });
  pythonEnv = (with pythonPackages; # note that checkInputs are missing!
    (with project_app; propagatedBuildInputs ++ propagatedNativeBuildInputs)
    ++ (with project_pkg; propagatedBuildInputs ++ propagatedNativeBuildInputs)
    ++ [
      #------------#
      # additional #
      #------------#
      decorator
      pyjson5
      toml
      #------------#
      # pydevtools #
      #------------#
      ipython
      pip
      pytest
      mypy
      pylint
      flake8
      yapf
      black
      #---------------#
      # documentation #
      #---------------#      
      jupyter-sphinx
      sphinx
      sphinx_rtd_theme
      nbformat
      nbconvert
    ]);
in (with pkgs;
  mkShell {
    buildInputs = [ pythonEnv ];
    nativeBuildInputs =
      [ cacert emacs-nox git gnumake nixfmt pandoc vscodeExt ]
      ++ [ black pythonEnv sphinx yapf ]; # jupyter
    shellHook = ''
      export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
      export PYTHONPATH=$PWD:$PYTHONPATH
    '';
  })