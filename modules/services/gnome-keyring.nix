{
  flake.modules.nixos.gnome-keyring = {
    # Enable keyring
    security = {
      pam.services = {
        login.enableGnomeKeyring = true;
      };
    };

    services = {
      gnome.gnome-keyring.enable = true;
    };
  };
}
