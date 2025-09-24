{
  sops,
  config,
  ...
}: {
  sops.secrets.location = {
    sopsFile = ../secrets.yaml;
    owner = "root";
    mode = "0555";
    key = "location";
  };
  services.wlsunset = {
    enable = true;
    latitude = "${config.sops.secrets.location.latitude}";
    longitude = "${config.sops.secrets.location.longitude}";
  };
}
