# This file defines overlays
{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  wlrootsNvidia = final: _prev: {
  	wlroots = _prev.wlroots.overrideAttrs(o: {
  		patches = (o.patches or [ ]) ++ [
  			./patches/nvidia.patch
  		];
  	});
  };

}
