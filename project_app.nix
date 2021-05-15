{ python3Packages, src }:
with python3Packages;
buildPythonApplication rec {
  pname = "cli_golden_python";
  version = "0.0";
  inherit src;

  buildInputs = [ ];
  nativeBuildInputs = [ ];
  propagatedBuildInputs = [ decorator jinja2 ];
  propagatedNativeBuildInputs = [ ];

  checkInputs = [ pytestCheckHook pyjson5 toml ];
  pytestFlagsArray = [ "tests" "-vv" ];
  # outputs = [ "bin" "dev" "doc" "out" ];
  # preInstall = ''
  #   mkdir -p $outputDoc
  #   mkdir -p $outputDoc/share/doc/dflkfld
  #   touch $outputDoc/share/doc/dflkfld/helloworld
  # '';
}
