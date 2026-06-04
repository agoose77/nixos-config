{
  flake.modules.nixos.hass-esphome = {
    config,
    pkgs,
    lib,
    ...
  }: {
    sops.secrets = {
      wifi-ssid = {
        sopsFile = ../secrets.yaml;
        owner = "root";
        mode = "0555";
        key = "wifi-ssid";
      };
      wifi-password = {
        sopsFile = ../secrets.yaml;
        owner = "root";
        mode = "0555";
        key = "wifi-password";
      };
    };
    sops.templates."living-room.yml".file = let
      livingRoomConfig = {
        esphome = {
          name = "esphome-web-fa8368";
          friendly_name = "Living Room ESP";
          min_version = "2025.11.0";
          name_add_mac_suffix = false;
        };
        esp32 = {
          board = "m5stack-atom";
          framework = {
            type = "arduino";
          };
        };
        logger = null;
        api = null;
        ota = [
          {
            platform = "esphome";
          }
        ];
        wifi = {
          ssid = config.sops.placeholder.wifi-ssid;
          password = config.sops.placeholder.wifi-password;
        };
        bluetooth_proxy = {
          active = true;
        };
      };
    in ((pkgs.formats.yaml {}).generate "living-room.yml" livingRoomConfig);

    virtualisation.oci-containers.containers.esphome = {
      ports = [
        "6052:6052"
      ];
      image = "ghcr.io/esphome/esphome:2026.5.2";
      volumes = [
        "${config.sops.templates."living-room.yaml".path}:/config/esp-living-room.yaml"
      ];
    };
  };
}
