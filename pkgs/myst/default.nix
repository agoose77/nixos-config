{pkgs}: let
  pkg = pkgs.stdenv.mkDerivation {
    name = "myst-src";
    installPhase = ''
      mv src/mystmd_py/myst.cjs $out
    '';
    src = pkgs.fetchPypi {
      pname = "mystmd";
      version = "1.6.0";
      hash = "sha256-dSNPdxVlwweZgHXUpn9XqhcyOu/JM/vR/CekN5xXHBo=";
    };
  };
in
  pkgs.writeShellApplication {
    name = "myst";
    runtimeInputs = [pkgs.nodejs_22];
    text = ''
      ${pkgs.lib.getExe' pkgs.nodejs_22 "node"} "${pkg}" "$@"
    '';
  }
