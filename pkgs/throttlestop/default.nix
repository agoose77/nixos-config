{
  pkgs,
  lib,
}: let
  python3 = pkgs.python3;
in
  python3.pkgs.buildPythonApplication rec {
    pname = "throttlestop";
    version = "0.0.6";
    pyproject = true;

    src = pkgs.fetchFromGitHub {
      owner = "agoose77";
      repo = "throttlestop";
      tag = "v${version}";
      hash = "sha256-xact08Nrdi/t2mlBjL4FQpxLIVxR/4qLd15HB4/FJj4";
    };
    build-system = with python3.pkgs; [
      hatchling
      setuptools-scm
    ];
    dependencies = with python3.pkgs; [
      numpy
      plumbum
      pkgs.msr-tools
    ];

    pythonImportsCheck = [
      "throttlestop"
    ];

    meta = with lib; {
      description = "Simple tool to manage thermal behaviour on Linux ";
      homepage = "https://github.com/agoose77/throttlestop";
      changelog = "https://github.com/agoose77/throttlestop/releases/tag/v${src.rev}";
      license = licenses.mit;
      maintainers = [];
      mainProgram = "throttlestop";
    };
  }
