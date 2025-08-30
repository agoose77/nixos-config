{config, ...}: {
  sops.secrets."influx-token" = {
    format = "yaml";
    # can be also set per secret
    sopsFile = ../secrets.yaml;
  };
  sops.secrets."influx-password" = {
    format = "yaml";
    # can be also set per secret
    sopsFile = ../secrets.yaml;
  };
  services.influxdb2 = {
    enable = true;
    provision = {
      enable = true;
        initialSetup = {
          bucket = "Home Assistant";
          organization = "home-assistant";
          retention = 31536000; # 1 year
          tokenFile = config.sops.secrets."influx-token".path;
          passwordFile = config.sops.secrets."influx-password".path;
          username = "admin";
        };
    };
  };
}
