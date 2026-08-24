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
      python3Packages.ipython
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
      nix-direnv.enable = true;
    };

    programs.atuin = {
      enableBashIntegration = false;
      forceOverwriteSettings = true;
      enable = true;
      daemon.enable = true;
    };
    # Enable atuin last. It needs to init before atuin, so let's just run it first as it's a simpler init script than atuins (easier to vendor here).
    programs.bash.initExtra = lib.mkOrder 10000 ''
      if [[ :$SHELLOPTS: =~ :(vi|emacs): ]]; then
        source "${pkgs.bash-preexec}/share/bash/bash-preexec.sh"
        eval "$(${lib.getExe pkgs.atuin} init bash )"
      fi
    '';

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
