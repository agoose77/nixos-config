{pkgs, ...}: {
  programs.rio = {
    enable = true;
    settings = {
      "confirm-before-quit" = false;
      theme = "dracula";
      fonts = {
        size = 24;
        family = "Fira Code";
      };
    };
  };
  xdg.configFile."rio/themes/dracula.toml".source =
    pkgs.fetchFromGitHub {
      owner = "dracula";
      repo = "rio-terminal";
      rev = "e59da7ce67e0be4a1d26191148714302071c10a8";
      hash = "sha256-+vKyIUqbHjsR1Gtw+oWpZpmFgnLv6wf9Q4eb666H2QI=";
    }
    + "/dracula.toml";
}
