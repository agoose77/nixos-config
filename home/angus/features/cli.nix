{pkgs, ...}: {
  home.packages = with pkgs; [
    alejandra
    bat
    bash
    curl
    comby
    httpie
    delta
    file
    sd
    fd
    fzf
    jq
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
    enableBashIntegration = true;
    nix-direnv.enable = true;
  };

  programs.atuin = {
    enable = true;
    enableBashIntegration = true;
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
}
