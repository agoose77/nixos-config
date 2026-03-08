{
  flake.modules = {
    nixos.kdeconnect = {
      programs.kdeconnect.enable = true;
    };
    homeManager.kdeconnect = {
      services.kdeconnect = {
        enable = true;
        indicator = true;
      };
    };
  };
}
