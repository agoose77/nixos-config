{
  config.flake.factory.autologin = username: {
    # users.mutableUsers = false;
    # Login as angus
    services.getty = {
      autologinUser = username;
      autologinOnce = true;
    };
  };
}
