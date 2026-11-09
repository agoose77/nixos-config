{inputs, ...}: {
  flake = {
    overlays.docker = _final: prev: {
      docker = let
        version = "29.6.2";
      in
        prev.docker.override {
          inherit version;
          cliRev = "v${version}";
          cliHash = "sha256-WpPSePMCfWAVxCkX1nZyI+sra/Vug009ZPmnVKDaX0I=";
          mobyRev = "docker-v${version}";
          mobyHash = "sha256-zrvrZCRUuiZ2vixZNOUFeGmDehHzSI+FzDMzV1gMqMc=";
          runcRev = "v1.3.6";
          runcHash = "sha256-cBMYZOElWHQ4OkF2NlYJSZrlW4833WD8CRJRkkXeKJc=";
          containerdRev = "v2.2.6";
          containerdHash = "sha256-Ngo9x847cXFYPnj/0I+g7BeV7e1/5T2YXfA1zkIdiPg=";
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
