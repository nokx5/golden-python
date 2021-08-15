{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

let
  vscodeExt = (with pkgs;
    vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          bbenoist.nix
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
  pythonEnv = pkgs.python3.withPackages (ps: with ps;
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
      # pip
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
    ] ++ pkgs.lib.optionals (!isPy39) [ python-language-server ]);
in
(with pkgs;
mkShell {
  buildInputs = [ pythonEnv ];
  nativeBuildInputs = [ bashCompletion bashInteractive cacert emacs-nox git gnumake less more nixpkgs-fmt pandoc ] ++ lib.optionals (hostPlatform.isLinux) [ vscodeExt ]
    ++ [ black pythonEnv sphinx yapf ];
  shellHook = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
    export PYTHONPATH=$PWD:$PYTHONPATH
  '';
})
