{
  config,
  lib,
  pkgs,
  ...
}: let
  frigateConfig = {
    mqtt = {
      enabled = true;
      user = "root";
      password = "{FRIGATE_MQTT_PASSWORD}";
      host = "mosquitto";
      port = 1883;
    };
    record = {
      enabled = false;
    };
    objects = {
      track = [
        "person"
        "dog"
      ];
    };
    face_recognition = {
      enabled = true;
    };
    snapshots = {
      enabled = true;
    };
    ffmpeg = {
      hwaccel_args = "preset-vaapi";
    };
    detectors = {
      coral = {
        type = "edgetpu";
        device = "usb";
      };
    };
    go2rtc = {
      webrtc = {
        candidates = [
          "192.168.68.63:8555"
          "100.77.82.8:8555"
        ];
      };
      streams = {
        tapo = [
          "rtsp://{FRIGATE_TAPO_USER_ESCAPED}:{FRIGATE_TAPO_CAMERA_PASSWORD_ESCAPED}@192.168.68.61:554/stream1"
          "tapo://admin:{FRIGATE_TAPO_ACCOUNT_PASSWORD_ESCAPED}@192.168.68.61"
        ];
        tapo-sub = [
          "rtsp://{FRIGATE_TAPO_USER_ESCAPED}:{FRIGATE_TAPO_CAMERA_PASSWORD_ESCAPED}@192.168.68.61:554/stream2"
        ];
        back-passage = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/101"
        ];
        back-passage-sub = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/102"
        ];
        front-drive = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/201"
        ];
        front-drive-sub = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/202"
        ];
        street = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/301"
        ];
        street-sub = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/302"
        ];
        garden = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/401"
        ];
        garden-sub = [
          "rtsp://admin:{FRIGATE_ANKE_PASSWORD_ESCAPED}@192.168.69.228:554/Streaming/Channels/402"
        ];
        doorbell = [
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD_ESCAPED}@192.168.68.56:554/Preview_01_main#backchannel=0"
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD_ESCAPED}@192.168.68.56:554/Preview_01_sub"
          "ffmpeg:doorbell#audio=opus#audio=copy"
        ];
        doorbell-sub = [
          "rtsp://admin:{FRIGATE_REOLINK_PASSWORD_ESCAPED}@192.168.68.56:554/Preview_01_sub"
        ];
      };
    };
    cameras = rec {
      tapo = {
        ffmpeg = {
          output_args = {
            record = "preset-record-generic-audio-copy";
          };
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/tapo";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
                "audio"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/tapo-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
              ];
            }
          ];
        };
        onvif = {
          host = "192.168.68.61";
          port = 2020;
          user = "{FRIGATE_TAPO_USER}";
          password = "{FRIGATE_TAPO_CAMERA_PASSWORD}";
        };
        motion = {
          mask = "0.367,0,0.367,0.077,0,0.082,0,0";
        };
        audio = {
          enabled = true;
          max_not_heard = 10;
          min_volume = 500;
          listen = [
            "bark"
            "fire_alarm"
          ];
        };
      };
      back-passage = {
        ffmpeg = {
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/back-passage";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/back-passage-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
              ];
            }
          ];
        };
        motion = {
          mask = [
            "0.018,0.053,0.241,0.056,0.242,0.022,0.015,0.022"
            "0.667,0.139,0.86,0.098,1,0.237,1,0,0.666,0"
          ];
        };
        zones = {
          Side_Boundary = {
            coordinates = "0.187,0.169,0.249,0.141,0.291,0.2,0.405,0.516,0.594,1,0.214,1,0.186,0.495";
            inertia = 3;
            loitering_time = 0;
          };
        };
      };
      front-drive = {
        ffmpeg = {
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/front-drive";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/front-drive-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
              ];
            }
          ];
        };
        motion = {
          mask = [
            "0.406,0.087,0.628,0.088,0.632,0.049,0.404,0.052"
            "0.813,0.052,0.946,0.052,0.947,0.084,0.814,0.084"
            "0.152,0,0.05,0.226,0,0.344,0.001,0"
          ];
        };
        objects = {
          filters = {
            person = {
            };
          };
        };
        zones = {
          Front_House = {
            coordinates = "0.657,0.154,0.625,0.375,0.301,0.636,0.057,0.887,0,1,0.79,1,0.938,0.429,0.948,0.363";
            inertia = 3;
            loitering_time = 0;
          };
        };
      };
      street = {
        ffmpeg = {
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/street";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/street-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
              ];
            }
          ];
        };
        motion = {
          mask = [
            "0.742,0.823,0.968,0.829,0.969,0.86,0.746,0.861"
            "0.858,0.909,0.932,0.911,0.936,0.946,0.861,0.943"
          ];
        };
        zones = {
          Road = {
            coordinates = "0.14,0.998,0.534,0.478,0.742,0.255,0.929,0.104,0.924,0,0,0,0,1";
            loitering_time = 0;
          };
          Boundary = {
            coordinates = "0.139,1,0.546,0.463,1,0.035,1,1";
            loitering_time = 0;
          };
        };
      };
      garden = {
        ffmpeg = {
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/garden";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/garden-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
              ];
            }
          ];
        };
        motion = {
          mask = [
            "0.021,0.052,0.241,0.057,0.237,0.023,0.02,0.025"
            "0.767,0.022,0.842,0.027,0.843,0.057,0.772,0.056"
          ];
          threshold = 30;
          contour_area = 10;
          improve_contrast = true;
        };
        objects = {
          mask = "0,0.432,0.078,0.355,0.039,0,0.001,0.003";
          track = [
            "person"
            "car"
            "dog"
          ];
        };
        zones = {
          Private_Driveway = {
            coordinates = "0.227,0.543,0.559,0.314,0.572,0.075,0.393,0.01,0.383,0.035,0.011,0.211,0.033,0.402,0.13,0.338";
            loitering_time = 0;
          };
          Raised_Garden = {
            coordinates = "0.488,0.377,0.791,0.176,0.998,0.332,1,0.869";
            loitering_time = 0;
          };
          Patio = {
            coordinates = "0.483,0.376,0.225,0.549,0.425,0.953,0.38,1,0.999,0.996,0.997,0.871";
            loitering_time = 0;
          };
        };
      };
      doorbell = {
        ffmpeg = {
          output_args = {
            record = "preset-record-generic-audio-aac";
          };
          inputs = [
            {
              path = "rtsp://127.0.0.1:8554/doorbell";
              input_args = "preset-rtsp-restream";
              roles = [
                "record"
              ];
            }
            {
              path = "rtsp://127.0.0.1:8554/doorbell-sub";
              input_args = "preset-rtsp-restream";
              roles = [
                "detect"
                "audio"
              ];
            }
          ];
        };
        zones = {
          Doorstep = {
            coordinates = "0.408,1,0.995,0.998,1,0.068,0.371,0.105";
            inertia = 3;
            loitering_time = 0;
            objects = "person";
            filters = {
              person = {
                min_area = 5000;
              };
            };
          };
        };
        audio = frigateConfig.cameras.tapo.audio;
        motion = {
          mask = "0.34,0.015,0.339,0.047,0.642,0.047,0.644,0.008";
        };
        review = {
          alerts = {
            required_zones = "Doorstep";
          };
        };
      };
    };
    version = "0.16-0";
    camera_groups = {
      Birdseye = {
        order = 1;
        icon = "LuBird";
        cameras = "birdseye";
      };
    };
    detect = {
      enabled = true;
    };
  };
  configFile = pkgs.writeTextFile {
    name = "config.yaml";
    text = lib.generators.toYAML {} frigateConfig;
  };
  secretsPath = lib.strings.removeSuffix ".yaml" config.sops.secrets.frigate-vars.path + "-escaped.env";

  pythonWithYaml = pkgs.python3.withPackages (python-pkgs:
    with python-pkgs; [
      # select Python packages here
      pyyaml
    ]);
in {
  networking.firewall.allowedTCPPorts = [8555];
  networking.firewall.allowedUDPPorts = [8555];

  sops.secrets.frigate-vars = {
    sopsFile = ../secrets.yaml;
    owner = "root";
    mode = "0555";
    key = "";
  };

  # Disable eDP-2 when keyboard plugged in
  systemd.services."build-frigate-env" = let
    script = pkgs.writeText "escape-env.py" ''
      from yaml import safe_load, dump
      from urllib.parse import quote
      with open("${config.sops.secrets.frigate-vars.path}", "r") as f:
          data = safe_load(f)

      env = {}
      for key, value in data.copy().items():
          env_key_suffix = key.replace("-", "_").upper()
          env_key = f"FRIGATE_{env_key_suffix}"
          env[f"{env_key}_ESCAPED"] = quote(value)
          env[env_key] = value

      lines = ["{0}={1}".format(*p) for p in env.items()]
      with open("${secretsPath}", "w") as f:
          f.write('\n'.join(lines))

    '';
  in {
    description = "URL encode secrets for frigate.";
    wantedBy = [(config.virtualisation.oci-containers.containers.frigate.serviceName + ".service")];
    serviceConfig = {
      Type = "oneshot";
      Restart = "on-failure";
    };
    enableStrictShellChecks = true;
    script = ''
      ${pythonWithYaml.interpreter} ${script}
    '';
  };

  virtualisation.oci-containers.containers.frigate = {
    environment = {
      FRIGATE_RTSP_PASSWORD = "password";
      LIBVA_DRIVER_NAME = "iHD";
    };
    environmentFiles = [secretsPath];
    ports = [
      "8971:8971"
      # RTSP
      "8554:8554"
      # Internal unauth
      "5000:5000"
      # WebRTC over TCP
      "8555:8555/tcp"
      # WebRTC over UDP
      "8555:8555/udp"
      # go2rtc interface
      "1984:1984"
    ];
    image = "ghcr.io/blakeblackshear/frigate:0.16.0";
    extraOptions = [
      "--device=/dev/bus/usb"
      "--device=/dev/dri"
      "--tmpfs=/tmp/cache:rw,size=1g,mode=1777"
      "--shm-size=256mb"
      "--network=mqtt-bridge"
      "--cap-add=PERFMON"
      "--group-add=keep-groups"
    ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/var/lib/frigate:/config"
      "${configFile}:/config/config.yaml:ro"
      "/mnt/data/media/frigate:/media/frigate"
    ];
  };

  # Ensure that frigate has a var directory
  system.activationScripts.makeVaultWardenDir = lib.stringAfter ["var"] ''
    mkdir -p /var/lib/frigate
  '';
}
