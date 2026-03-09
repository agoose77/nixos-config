{
  flake.modules.nixos.autologin-angus = {
    # users.mutableUsers = false;
    # Login as angus
    services.getty = {
      autologinUser = "angus";
      autologinOnce = true;
    };
  };
}
