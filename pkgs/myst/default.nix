{pkgs}: let
  node = pkgs.nodejs_22;
in
  pkgs.stdenv.mkDerivation {
    name = "myst";
    nativeBuildInputs = [
      pkgs.makeBinaryWrapper
    ];
    installPhase = ''
      runHook preInstall

      install -D src/mystmd_py/myst.cjs $out/share/mystmd/myst.cjs

      # Create a wrapper around the node binary that sets PATH and prepends the script
      # This is more nix-like than just creating a wrapper shell script ourselves.
      makeBinaryWrapper ${pkgs.lib.getExe node} "$out/bin/myst" \
        --add-flags "$out/share/mystmd/myst.cjs" \
        --prefix PATH : ${pkgs.lib.makeBinPath [node]}

      runHook postInstall
    '';
    src = pkgs.fetchPypi {
      pname = "mystmd";
      version = "1.6.0";
      hash = "sha256-dSNPdxVlwweZgHXUpn9XqhcyOu/JM/vR/CekN5xXHBo=";
    };
    meta = {
      description = "The MyST Markdown Command Line interface.";
      homepage = "https://github.com/Misterio77/minicava";
      license = licenses.mit;
      platforms = platforms.all;
      mainProgram = "myst";
    };
  }
