{pkgs, ...}: {
  stylix = {
    enable = true;

    /*
    We'll take over styling
    */
    targets.waybar.addCss = false;

    base16Scheme =
      pkgs.fetchFromGitHub {
        owner = "dracula";
        repo = "base16-dracula-scheme";
        rev = "master";
        hash = "sha256-iHe/Y0+yubXseh3gMWb6wZ4rIb1GAlb6iQNVgiEncfI=";
      }
      + "/dracula.yaml";
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.fira-code;
        name = "Fira Code";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
    };
  };
}
