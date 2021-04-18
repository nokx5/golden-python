{ pkgs ? import <nokxpkgs> { } }:
with pkgs;

let
  packageOverrides = python-self: python-super: {
    # golden_python = golden_python.overrideAttr
    golden_python = python-super.golden_python.overrideAttrs (oldAttrs: rec {
      src = pkgs.nix-gitignore.gitignoreSource [ ".git" ] ./.;
      # propagatedBuildInputs = oldAttrs.propagatedBuildInputs
      #   ++ (with python-self; [ ]);
    });
  };

  python3 = pkgs.python3.override (old: {
    packageOverrides =
      stdenv.lib.composeExtensions (old.packageOverrides or (_: _: { }))
      packageOverrides;
  });
  python3Packages = python3.pkgs;

in { inherit python3 python3Packages; }

