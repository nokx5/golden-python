with (import <nixpkgs> { });

with python3;

let
  pythonEnv = withPackages (ps:
    with ps; [
      regex
      decorator
      APScheduler
      typed-ast
      jinja2
      pyjson5
      toml
      numpy
      pip
      #------------#
      # pydevtools #
      #------------#
      sphinx
      sphinx_rtd_theme
      nbformat
      nbconvert
      pandoc
      nbsphinx
      pytest
      mypy
      pylint
      flake8
      # yapf
      black
    ]);

in mkShell {
  buildInputs = [ pythonEnv black gnumake ];
  shellHook = ''
    export PYTHONPATH=$PWD:$PYTHONPATH
  '';
}
