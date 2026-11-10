{inputs, ...}: {
  flake = {
    overlays.docker = _final: prev: {
      docker = let
        version = "29.1.2";
      in
        prev.docker.override {
          inherit version;
          cliRev = "v${version}";
          cliHash = "sha256-dmoCHxXOYalJCaqq32MdsAEJ+xq0aH/8fOpJHVnBxxU=";
          mobyRev = "docker-v${version}";
          mobyHash = "sha256-SRMaPAdg2nlWuKKQILZEGHZO6TGLh2Ci1UIWqcyo6IM=";
          runcRev = "v1.3.4";
          runcHash = "sha256-1IfY08sBoDpbLrwz1AKBRSTuCZyOgQzYPHTDUI6fOZ8=";
          containerdRev = "v2.2.0";
          containerdHash = "sha256-LXBGA03FTrrbxlH+DxPBFtp3/AYQf096YE2rpe6A+WM=";
          tiniRev = "369448a167e8b3da4ca5bca0b3307500c3371828";
          tiniHash = "sha256-jCBNfoJAjmcTJBx08kHs+FmbaU82CbQcf0IVjd56Nuw=";
        };
    };
    modules = {
      nixos.docker = {
        virtualisation.docker.enable = true;
        nixpkgs.overlays = [inputs.self.overlays.docker];
      };
    };
  };
}
