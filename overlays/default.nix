# This file defines overlays
{...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  modifications = final: prev: {
    # example = prev.example.overrideAttrs (oldAttrs: rec {
    # ...
    # });
    "helvetica-neue-lt-std" = prev."helvetica-neue-lt-std".overrideAttrs (oldAttrs: {
      src = prev.fetchzip {
        url = "https://media.fontsgeek.com/download/zip/h/e/helvetica-neue-lt-std_vpEc1.zip";
        stripRoot = false;
        hash = "sha256-GhqT/2OTzAtBoADp58uDrLszgJLbeylgM17qxUuBm+k=";
      };

      installPhase = ''
        runHook preInstall

        install -Dm644 'Helvetica Neue LT Std'/**/*.otf -t $out/share/fonts/opentype

        runHook postInstall
      '';
      meta.homepage = "https://media.fontsgeek.com/download/zip/h/e/helvetica-neue-lt-std_vpEc1.zip";
    });

    wlrootsNvidia = final: _prev: {
      wlroots = _prev.wlroots.overrideAttrs (o: {
        patches =
          (o.patches or [])
          ++ [
            ./patches/nvidia.patch
          ];
      });
    };
  };
}
