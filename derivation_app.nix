{ python3Packages, src, nbconvert, pandoc }:
with python3Packages;
buildPythonApplication rec {
  pname = "cli_golden_python";
  version = "0.0";
  inherit src;

  buildInputs = [ ];
  nativeBuildInputs = [ pandoc nbconvert ] ++ [ sphinx sphinx_rtd_theme ];
  propagatedBuildInputs = [ decorator jinja2 ];
  propagatedNativeBuildInputs = [ ];

  checkInputs = [ pytestCheckHook pyjson5 toml ];
  pytestFlagsArray = [ "tests" "-vv" ];

  outputs = [ "doc" "out" ];
  preInstall = ''
    mkdir -p $doc/html
    make html -C $src/docs DESTINATION=$TMP/tmp-doc
    mv $TMP/tmp-doc/build-target/html/* $doc/html/
  '';
}
