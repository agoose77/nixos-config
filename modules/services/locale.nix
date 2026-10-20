{
  flake.modules.nixos.locale = {
    config,
    pkgs,
    ...
  }: {
    # Timezone
    services.automatic-timezoned.enable = true;
    location.provider = "geoclue2";

    i18n.defaultLocale = "en_GB.UTF-8";

    console.keyMap = "uk";
    services.xserver.xkb = {
      layout = "gb";
      variant = "";
    };

    # Pass in Google API token
    sops.secrets.google-maps-api-key = {
      format = "yaml";
      sopsFile = ./secrets.yaml;
    };

    sops.templates."provider.conf" = {
      file =
        (
          (pkgs.formats.ini {}).generate "provider.conf" {
            wifi = {
              url = "https://www.googleapis.com/geolocation/v1/geolocate?key=${config.sops.placeholder.google-maps-api-key}";
            };
            # See https://github.com/ebrensi/PC/blob/ef48f7d13c90cc8349f17490a7cf3ba44de2fe62/base.nix#L111-L117
            ip = {
              enable = true;
              method = "ichnaea";
            };
          }
        ).outPath;
      mode = "444";
    };
    environment.etc."geoclue/conf.d/provider.conf".source = config.sops.templates."provider.conf".path;
  };
}
