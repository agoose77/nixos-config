{
  flake.modules.nixos.locale = {config, ...}: {
    # Timezone
    services.automatic-timezoned.enable = true;
    location.provider = "geoclue2";
    services.geoclue2.geoProviderUrl = "https://www.googleapis.com/geolocation/v1/geolocate?key=${config.sops.placeholder.google-maps-api-key}";

    i18n.defaultLocale = "en_GB.UTF-8";

    console.keyMap = "uk";
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };

    sops.secrets = {
      google-maps-api-key = {
        format = "yaml";
        # can be also set per secret
        sopsFile = ./secrets.yaml;
        mode = "0555";
      };
    };
  };
}
