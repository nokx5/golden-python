{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

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
          ms-toolsai.jupyter
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
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
  pythonEnv = (with pythonPackages;
    [
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
      python-language-server
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
in
(with pkgs;
mkShell {
  buildInputs = [ pythonEnv ];
  nativeBuildInputs = [ cacert emacs-nox git gnumake less more nixpkgs-fmt pandoc ] ++ lib.optionals (hostPlatform.isLinux) [ vscodeExt ]
    ++ [ black pythonEnv sphinx yapf ];
  shellHook = ''
    export SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt
    export PYTHONPATH=$PWD:$PYTHONPATH
  '';
})
