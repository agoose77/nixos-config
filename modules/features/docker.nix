{inputs, ...}: {
  flake = {
    overlays.docker = _final: prev: {
      docker = prev.docker.override {
        containerd = prev.containerd.overrideAttrs (old: rec {
          version = "2.3.5";
          src = _final.fetchFromGitHub {
            owner = "containerd";
            repo = "containerd";
            tag = "v${version}";
            hash = "sha256-RIZxlXwgOizLVKr4XRIKAlUP19URolGp4J849hoQMSM=";
          };
        });
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
