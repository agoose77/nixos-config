{
  flake.modules.nixos.hass-esphome = {
    config,
    pkgs,
    lib,
    ...
  }: let
    deviceNames = {
      living-room = "Living Room";
      kitchen = "Kitchen";
    };
    baseESPConfig = {
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
  in {
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
    sops.templates =
      lib.mapAttrs (
        name: display: ((pkgs.formats.yaml {}).generate "${name}.yaml" baseESPConfig
          // {
            esphome = {
              name = "esphome-web-fa8368";
              friendly_name = "${display} ESP";
              min_version = "2025.11.0";
              name_add_mac_suffix = false;
            };
          })
      )
      deviceNames;

    virtualisation.oci-containers.containers.esphome = {
      ports = [
        "6052:6052"
      ];
      image = "ghcr.io/esphome/esphome:2026.5.2";
      volumes = lib.mapAttrsToList (name: value: "${config.sops.templates."${name}".path}:/config/${name}.yaml") deviceNames;
    };
  };
}
