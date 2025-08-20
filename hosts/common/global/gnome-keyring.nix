{
  # Enable keyring
  security = {
    pam.services = {
      login.enableGnomeKeyring = true;
    };
  };

  services = {
    gnome.gnome-keyring.enable = true;
  };
}
