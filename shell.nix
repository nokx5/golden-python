{ pkgs ? import <nixpkgs> { config.allowUnfree = true; } }:

with pkgs;
assert hostPlatform.isx86_64;

let
  vscodeExt = vscode-with-extensions.override {
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
  };
  pythonEnv = python3.withPackages (ps: with ps; [
    #------------#
    # additional #
    #------------#
    decorator
    pyjson5
    toml
    #------------#
    # pydevtools #
    #------------#
    black
    flake8
    ipython
    mypy
    pylint
    pip
    # pygls
    # pyls-black
    # pyls-mypy
    pytest
    yapf
    #---------------#
    # documentation #
    #---------------#
    jupyter-sphinx
    sphinx
    sphinx_rtd_theme
    nbformat
    nbconvert
  ] ++ lib.optionals (!isPy39) [ python-language-server ]);
in
mkShell {
  propagatedBuildInputs = [ pythonEnv ];
  nativeBuildInputs = [ bashCompletion bashInteractive cacert emacs-nox git gnumake less more nixpkgs-fmt pandoc ] ++ lib.optionals (hostPlatform.isLinux) [ vscodeExt ]
    ++ [ black sphinx yapf ];
  buildInputs = [ ] ++ lib.optionals (hostPlatform.isLinux) [ glibcLocales ];

  LANG = "en_US.UTF-8";

  shellHook = ''
    export HOME=$(pwd)
    export PYTHONPATH=$PWD:$PYTHONPATH
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt
  '';
}
