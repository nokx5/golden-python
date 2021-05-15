{ buildPythonPackage, src, decorator, jinja2, pyjson5, pytestCheckHook, toml }:

buildPythonPackage rec {
  pname = "golden_python";
  version = "0.0";
  inherit src;

  buildInputs = [ ];
  nativeBuildInputs = [ ];
  propagatedBuildInputs = [ decorator jinja2 pyjson5 toml ];
  propagatedNativeBuildInputs = [ ];

  checkInputs = [ pytestCheckHook ];
  pytestFlagsArray = [ "tests" "-vv" ];
  # outputs = [ "bin" "dev" "doc" "out" ];
  # preInstall = ''
  #   mkdir -p $outputDoc
  #   mkdir -p $outputDoc/share/doc/dflkfld
  #   touch $outputDoc/share/doc/dflkfld/helloworld
  # '';
}
