{
  flake.modules.homeManager.cli = {
    config,
    lib,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      alejandra
      bat
      bash
      curl
      # Broken:
      # comby
      httpie
      delta
      file
      sd
      fd
      fzf
      jq
      yq-go
      oils-for-unix
      unzip
      wl-clipboard
      zip
      watchexec
    ];
    programs.ripgrep.enable = true;
    programs.bash.enable = true;

    programs.direnv = {
      enable = true;
      enableBashIntegration = false;
      nix-direnv.enable = true;
    };
    # Enable direnv first. It needs to init before atuin, so let's just run it first as it's a simpler init script than atuins (easier to vendor here).
    programs.bash.initExtra = lib.mkBefore ''
      eval "$(${lib.getExe config.programs.direnv.package} hook bash)"
    '';

    programs.atuin = {
      enable = true;
      enableBashIntegration = true;
      daemon.enable = true;
    };

    programs.starship = {
      enable = true;
      settings = {
        gcloud = {
          disabled = true;
        };
        kubernetes = {
          disabled = false;
          contexts = [
            {
              context_pattern = "^arn:aws:eks.*:cluster/(.*)$";
              context_alias = "aws.$1";
            }
            {
              context_pattern = "^gke.*_([^_]*)$";
              context_alias = "gcp.$1";
            }
          ];
        };
      };
    };
    programs.btop.enable = true;
    programs.eza.enable = true;
    programs.zoxide = {
      enable = true;
      enableBashIntegration = true;
    };
    home.sessionVariables = {
      _ZO_DOCTOR = "0";
    };
  };
}
