# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  additions = final: _prev: import ../pkgs final.pkgs;

  wlrootsNvidia = final: _prev: {
    wlroots = _prev.wlroots.overrideAttrs (o: {
      patches =
        (o.patches or [])
        ++ [
          ./patches/nvidia.patch
        ];
    });
  };
}
