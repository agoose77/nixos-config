{config, ...}: let
  configFile = {
    sopsFile = ../secrets.yaml;
    owner = "root";
    mode = "0755";
  };
in {
  networking.firewall.allowedTCPPorts = [8555];
  networking.firewall.allowedUDPPorts = [8555];

  sops.secrets.mqtt-password = configFile;
  sops.secrets.tapo-user = configFile;
  sops.secrets.tapo-password = configFile;
  sops.secrets.tapo-camera-password = configFile;
  sops.secrets.anke-password = configFile;
  sops.secrets.reolink-password = configFile;

  environment.etc."frigate/config.yaml".source = config.sops.templates."frigate-config.yaml".path;
  sops.templates."frigate-config.yaml" = {
    content = ''
      mqtt:
        enabled: true
        user: root
        password: "${config.sops.placeholder.mqtt-password}"
        host: mosquitto
        port: 1883

      record:
        enabled: false

      objects:
        track:
          - person
          - dog

      snapshots:
        enabled: true # <-- retains snapshots for 10 days on default

      # TODO: use GPU
      ffmpeg:
        hwaccel_args: preset-vaapi

      detectors:
        coral:
          type: edgetpu
          device: usb
      go2rtc:
        webrtc:
          candidates:
            # Browser needs to find frigate over local network
            - 192.168.68.63:8555
            # Need to use direct IP instead
            # - home-assistant.tail12edf.ts.net:8555
            - 100.77.82.8:8555
        # Direct connections to camera, used for webRTC
        # `camera` section uses these connections
        # These are "high-res"
        streams:
          tapo:
            - rtsp://${config.sops.placeholder.tapo-user}:${config.sops.placeholder.tapo-password}@192.168.68.61:554/stream1
            - tapo://admin:${config.sops.placeholder.tapo-camera-password}@192.168.68.61
            #- ffmpeg:tapo#video=copy#audio=aac
          tapo-sub:
            - rtsp://${config.sops.placeholder.tapo-user}:${config.sops.placeholder.tapo-password}@192.168.68.61:554/stream2
          back-passage:
            - rtsp://admin:${config.sops.placeholder.mqtt-password}@192.168.69.228:554/Streaming/Channels/101
          back-passage-sub:
            - rtsp://admin:${config.sops.placeholder.anke-password}@192.168.69.228:554/Streaming/Channels/102
          front-drive:
            - rtsp://admin:${config.sops.placeholder.anke-password}@192.168.69.228:554/Streaming/Channels/201
          front-drive-sub:
            - rtsp://admin:${config.sops.placeholder.anke-password}@192.168.69.228:554/Streaming/Channels/202
          street:
            - rtsp://admin:${config.sops.placeholder.anke-password}@192.168.69.228:554/Streaming/Channels/301
          street-sub:
            - rtsp://admin:${config.sops.placeholder.anke-password}@192.168.69.228:554/Streaming/Channels/302
          garden:
            - rtsp://admin:${config.sops.placeholder.anke-password}@192.168.69.228:554/Streaming/Channels/401
          garden-sub:
            - rtsp://admin:${config.sops.placeholder.anke-password}@192.168.69.228:554/Streaming/Channels/402
          doorbell:
            # This is fragile. This config was taken from https://www.reddit.com/r/homeassistant/comments/1jxl3ay/frigate_reolink_doorbell_integration_2way_voice/
            - rtsp://admin:${config.sops.placeholder.reolink-password}@192.168.68.56:554/Preview_01_main#backchannel=0    # think this disables return audio for the main stream (∴ only one sender)
            - rtsp://admin:${config.sops.placeholder.reolink-password}@192.168.68.56:554/Preview_01_sub    # substream for return audio?
            - ffmpeg:doorbell#audio=opus#audio=copy
          doorbell-sub:
            - rtsp://admin:${config.sops.placeholder.reolink-password}@192.168.68.56:554/Preview_01_sub

      cameras:
        tapo:
          ffmpeg:
            output_args:
              record: preset-record-generic-audio-copy
            inputs:
              - path: rtsp://127.0.0.1:8554/tapo
                input_args: preset-rtsp-restream
                roles:
                  - record
                  - audio
              - path: rtsp://127.0.0.1:8554/tapo-sub
                input_args: preset-rtsp-restream
                roles:
                  - detect
          onvif:
            host: 192.168.68.61
            port: 2020
            user: goosey15@gmail.com
            password: dramallama123
          motion:
            mask: 0.367,0,0.367,0.077,0,0.082,0,0

          # Optional: Audio Events Configuration
          # NOTE: Can be overridden at the camera level
          audio: &audio
            # Optional: Enable audio events (default: shown below)
            enabled: true
            # Optional: Configure the amount of seconds without detected audio to end the event (default: shown below)
            max_not_heard: 10
            # Optional: Configure the min rms volume required to run audio detection (default: shown below)
            # As a rule of thumb:
            #  - 200 - high sensitivity
            #  - 500 - medium sensitivity
            #  - 1000 - low sensitivity
            min_volume: 500
            listen:
              - bark
              - fire_alarm
        back-passage:
          ffmpeg:
            inputs:
              - path: rtsp://127.0.0.1:8554/back-passage
                input_args: preset-rtsp-restream
                roles:
                  - record
              - path: rtsp://127.0.0.1:8554/back-passage-sub
                input_args: preset-rtsp-restream
                roles:
                  - detect
          motion:
            mask:
              - 0.018,0.053,0.241,0.056,0.242,0.022,0.015,0.022
              - 0.667,0.139,0.86,0.098,1,0.237,1,0,0.666,0
          zones:
            Side_Boundary:
              coordinates:
                0.187,0.169,0.249,0.141,0.291,0.2,0.405,0.516,0.594,1,0.214,1,0.186,0.495
              inertia: 3
              loitering_time: 0
        front-drive:
          ffmpeg:
            inputs:
              - path: rtsp://127.0.0.1:8554/front-drive
                input_args: preset-rtsp-restream
                roles:
                  - record
              - path: rtsp://127.0.0.1:8554/front-drive-sub
                input_args: preset-rtsp-restream
                roles:
                  - detect
          motion:
            mask:
              - 0.406,0.087,0.628,0.088,0.632,0.049,0.404,0.052
              - 0.813,0.052,0.946,0.052,0.947,0.084,0.814,0.084
              - 0.152,0,0.05,0.226,0,0.344,0.001,0
          objects:
            filters:
              person: {}
          zones:
            Front_House:
              coordinates:
                0.657,0.154,0.625,0.375,0.301,0.636,0.057,0.887,0,1,0.79,1,0.938,0.429,0.948,0.363
              inertia: 3
              loitering_time: 0
        street:
          ffmpeg:
            inputs:
              - path: rtsp://127.0.0.1:8554/street
                input_args: preset-rtsp-restream
                roles:
                  - record
              - path: rtsp://127.0.0.1:8554/street-sub
                input_args: preset-rtsp-restream
                roles:
                  - detect
          motion:
            mask:
              - 0.742,0.823,0.968,0.829,0.969,0.86,0.746,0.861
              - 0.858,0.909,0.932,0.911,0.936,0.946,0.861,0.943
          zones:
            Road:
              coordinates:
                0.14,0.998,0.534,0.478,0.742,0.255,0.929,0.104,0.924,0,0,0,0,1
              loitering_time: 0
            Boundary:
              coordinates: 0.139,1,0.546,0.463,1,0.035,1,1
              loitering_time: 0
        garden:
          ffmpeg:
            inputs:
              - path: rtsp://127.0.0.1:8554/garden
                input_args: preset-rtsp-restream
                roles:
                  - record
              - path: rtsp://127.0.0.1:8554/garden-sub
                input_args: preset-rtsp-restream
                roles:
                  - detect

          motion:
            mask:
              - 0.021,0.052,0.241,0.057,0.237,0.023,0.02,0.025
              - 0.767,0.022,0.842,0.027,0.843,0.057,0.772,0.056
            threshold: 30
            contour_area: 10
            improve_contrast: true
          objects:
            mask: 0,0.432,0.078,0.355,0.039,0,0.001,0.003
          # Also track cars!
            track:
              - person
              - car
              - dog
          zones:
            Private_Driveway:
              coordinates:
                0.227,0.543,0.559,0.314,0.572,0.075,0.393,0.01,0.383,0.035,0.011,0.211,0.033,0.402,0.13,0.338
              loitering_time: 0
            Raised_Garden:
              coordinates: 0.488,0.377,0.791,0.176,0.998,0.332,1,0.869
              loitering_time: 0
            Patio:
              coordinates:
                0.483,0.376,0.225,0.549,0.425,0.953,0.38,1,0.999,0.996,0.997,0.871
              loitering_time: 0
        doorbell:
          ffmpeg:
            output_args:
              record: preset-record-generic-audio-aac
            inputs:
              - path: rtsp://127.0.0.1:8554/doorbell
                input_args: preset-rtsp-restream
                roles:
                  - record
              - path: rtsp://127.0.0.1:8554/doorbell-sub
                input_args: preset-rtsp-restream
                roles:
                  - detect
                  - audio
          zones:
            Doorstep:
              coordinates: 0.408,1,0.995,0.998,1,0.068,0.371,0.105
              inertia: 3
              loitering_time: 0
              objects: person
              filters:
                person:
                  min_area: 5000
          audio: *audio
          motion:
            mask: 0.34,0.015,0.339,0.047,0.642,0.047,0.644,0.008
          review:
            alerts:
              required_zones: Doorstep
      version: 0.16-0
      camera_groups:
        Birdseye:
          order: 1
          icon: LuBird
          cameras: birdseye
      detect:
        enabled: true
    '';
    mode = "0755";
  };

  virtualisation.oci-containers.containers.frigate = {
    environment = {
      FRIGATE_RTSP_PASSWORD = "password";
      LIBVA_DRIVER_NAME = "i965";
    };
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
      "--device=/dev/dri/renderD128"
      "--device=/dev/dri/renderD129"
      "--device=/dev/dri/card2"
      "--device=/dev/dri/card1"
      "--tmpfs=/tmp/cache:rw,size=1g,mode=1777"
      "--shm-size=256mb"
      "--network=mqtt-bridge"
      "--cap-add=PERFMON"
      "--group-add=keep-groups"
    ];
    volumes = [
      "/etc/localtime:/etc/localtime:ro"
      "/etc/frigate:/config"
      "/mnt/data/media/frigate:/media/frigate"
    ];
  };
}
