{ pkgs }:
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
        }];
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
      sphinx
      sphinx_rtd_theme
      nbformat
      nbconvert
      nbsphinx
    ]);
in pkgs.mkShell {
  buildInputs = (with pkgs; [ pythonEnv ]);
  nativeBuildInputs = (with pkgs;
    [ emacs-nox cacert git gnumake nixfmt pandoc typora vscodeExt ]
    ++ [ black jupyter pythonEnv sphinx yapf ]);
  shellHook = ''
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    export PYTHONPATH=$PWD:$PYTHONPATH
  '';
}
