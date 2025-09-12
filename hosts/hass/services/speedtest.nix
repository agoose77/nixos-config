{config, ...}: let
  keyPath = "/run/secrets/app_key";
in {
  sops.secrets."speedtest-key" = {
    format = "yaml";
    # can be also set per secret
    sopsFile = ../secrets.yaml;
    mode = "0555";
  };
  virtualisation.oci-containers.containers.speedtest-tracker = {
    environment = {
      TZ = "Europe/London";
      SPEEDTEST_SCHEDULE = "0 */1 * * *";
      FILE__APP_KEY = keyPath;
      PRUNE_RESULTS_OLDER_THAN = 14;
    };
    ports = [
      "4898:80"
    ];
    image = "lscr.io/linuxserver/speedtest-tracker:1.6.6";
    volumes = [
      "/etc/speedtest-tracker/data:/config"
      "${config.sops.secrets."speedtest-key".path}:${keyPath}"
    ];
  };
}
