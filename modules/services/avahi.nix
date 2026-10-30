{
  flake.modules.nixos.avahi = {
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      nssmdns6 = true;
      settings = {
        reflector.enable-reflector = true;
        publish.disable-publishing = false;
        publish.disable-user-service-publishing = false;
      };
    };
  };
}
