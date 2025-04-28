# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];
  nixpkgs = {
    # You can add overlays here
    overlays = [
      # Add overlays your own flake exports (from overlays and pkgs dir):
      outputs.overlays.wlrootsNvidia
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
    };
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    alejandra
    git
    curl
    podman
    neovim
    tailscale
  ];
  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: {inherit flake;})) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = ["/etc/nix/path"];
  environment.etc =
    lib.mapAttrs'
    (name: value: {
      name = "nix/path/${name}";
      value.source = value.flake;
    })
    config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "i965";
  };
  networking = {
    hostName = "home-assistant";
    networkmanager.enable = true;
    interfaces."enp4s0".macAddress = "20:47:47:79:c5:7d";
  };
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  console.keyMap = "uk";

  # TODO: This is just an example, be sure to use whatever bootloader you prefer
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    angus = {
      isNormalUser = true;
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel" "media"];
      packages = with pkgs; [];
      shell = pkgs.bash;
      uid = 1000;
    };
  };
  # Choose group ID for media
  users.groups.media.gid = 501;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Budgie Desktop environment.
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.desktopManager.budgie.enable = true;

  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  programs.ssh.startAgent = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

  systemd.services.init-mqtt-network = {
    description = "Create the network bridge for mqtt.";
    after = ["network.target"];
    wantedBy = ["multi-user.target"];
    serviceConfig.Type = "oneshot";
    script = ''
      # Put a true at the end to prevent getting non-zero return code, which will
          	  # crash the whole service.
      if ! ${pkgs.podman}/bin/podman network exists mqtt-bridge; then
        ${pkgs.podman}/bin/podman network create mqtt-bridge
      else
      	    echo "mqtt-bridge already exists"
       fi
    '';
  };

  # Support DNS within bridge networks
  # c.f. https://github.com/NixOS/nixpkgs/issues/226365#issuecomment-2164985192
  networking.firewall.interfaces."podman+".allowedUDPPorts = [53 5353];
  virtualisation = {
    podman = {
      enable = true;

      # Create a `docker` alias for podman, to use it as a drop-in replacement
      dockerCompat = true;

      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
    oci-containers = {
      backend = "podman";
      containers.home-assistant = {
        environment.TZ = "Europe/London";
        # This fixes a bug
        environment.PYTHONPATH = "/usr/local/lib/python3.13:/config/deps";
        image = "ghcr.io/home-assistant/home-assistant:2025.4.0b1"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--network=host"
          "--cap-add=NET_RAW"
          #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
        ];
        volumes = [
          "/etc/home-assistant:/config"
        ];
      };
      # SpeedTest
      containers.speedtest-tracker = {
        environment.TZ = "Europe/London";
        environment.SPEEDTEST_SCHEDULE = "0 */1 * * *";
        environment.APP_KEY = "base64:Xn3dUpdHB0Id07Q2KdLT5Qrf2MvgpSGkS6jL4cWXBWg=";
        ports = [
          "4898:80"
        ];
        image = "lscr.io/linuxserver/speedtest-tracker:latest";
        volumes = [
          "/etc/speedtest-tracker/data:/config"
        ];
      };
      # Mosquitto
      containers.mosquitto = {
        ports = [
          "1883:1883"
          "9001:9001"
        ];
        image = "docker.io/eclipse-mosquitto:latest";
        volumes = [
          "/etc/mosquitto/config:/mosquitto/config"
        ];
        extraOptions = [
          "--network=mqtt-bridge"
        ];
      };
      # Frigate
      containers.frigate = {
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
        image = "ghcr.io/blakeblackshear/frigate:0.15.0";
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
          "/etc/frigate/config:/config"
          "/media/frigate:/media/frigate"
        ];
      };
      # qbittorrent
      containers.qbittorrent = {
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
        image = "lscr.io/linuxserver/qbittorrent:5.0.4";
        volumes = [
          "/etc/qbittorrent/data:/config"
          "/media/torrent:/downloads"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      # gluetun
      # Might need to order this before torrents: https://discourse.nixos.org/t/oci-containers-with-systemd-unit-dependencies/26029
      containers.gluetun = {
        environment = {
          VPN_SERVICE_PROVIDER = "windscribe";
          VPN_TYPE = "openvpn";
          SERVER_REGIONS = "United Kingdom";
        };

        ports = [
          # Ports for qbittorrent!
          "8080:8080"
          "6881:6881"
          "6881:6881/udp"
          # Ports for sonarr
          "8989:8989"
          # Ports for prowlarr
          "9696:9696"
        ];
        image = "docker.io/qmcgaw/gluetun:latest";
        volumes = [
          "/etc/gluetun/secrets:/run/secrets"
        ];
        extraOptions = [
          "--cap-add=NET_ADMIN"
          "--device=/dev/net/tun"
        ];
      };
      # Prowlarr
      containers.prowlarr = {
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
        image = "lscr.io/linuxserver/prowlarr:1.34.1";
        volumes = [
          "/etc/prowlarr/data:/config"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      # Sonarr
      containers.sonarr = {
        environment = {
          PUID = "1000";
          PGID = "1000";
        };
        image = "lscr.io/linuxserver/sonarr:4.0.14";
        volumes = [
          "/etc/sonarr/data:/config"
          "/media/tv:/tv"
          "/media/torrent:/downloads"
        ];
        extraOptions = [
          "--network=container:gluetun"
        ];
      };
      # Jellyfin
      containers.jellyfin = {
        environment = {
          PUID = "1000";
          PGID = "1000";

          LIBVA_DRIVER_NAME = "i965";
        };
        image = "lscr.io/linuxserver/jellyfin:10.10.7";
        volumes = [
          "/etc/jellyfin/data:/config"
          "/media/tv:/tv"
        ];
        ports = [
          "8096:8096"
          "7359:7359/udp"
          "1900:1900/udp"
        ];
        extraOptions = [
          "--device=/dev/dri:/dev/dri"
        ];
      };
    };
    containers.enable = true;
  };

  services.tailscale = {
    enable = true;
    port = 12345;
    # Allow Caddy to user to manage and create certs
    permitCertUid = "caddy";
  };

  services.caddy = rec {
    enable = true;

    # Auto-HTTPS remote routing
    virtualHosts."home-assistant.tail12edf.ts.net".extraConfig = ''
      reverse_proxy localhost:8123

      redir /jellyfin /jellyfin/
      reverse_proxy /jellyfin/* localhost:8096

      redir /sonarr /sonarr/
      reverse_proxy /sonarr/* localhost:8989

      redir /prowlarr /prowlarr/
      reverse_proxy /prowlarr/* localhost:9696

      redir /qbittorrent /qbittorrent/
      handle_path /qbittorrent/* {
	      reverse_proxy localhost:8080
      }
    '';

    # For HTTP-only local routing
    virtualHosts."home-assistant.local".extraConfig = virtualHosts."home-assistant.tail12edf.ts.net".extraConfig;
  };

  #services.xserver.videoDrivers = ["nvidia"];
  hardware.opengl = {
    enable = true;
    # For better video playback
    extraPackages = with pkgs; [nvidia-vaapi-driver];
  }; #

  #hardware.nvidia = {
  #  modesetting.enable = true;
  #  open = false;
  #  nvidiaSettings = true;
  #  package = config.boot.kernelPackages.nvidiaPackages.stable;
  #};

  hardware.pulseaudio.enable = false;
  hardware.coral.usb.enable = true;

  services = {
    pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };
  };

  networking.firewall.allowedTCPPorts = [80 443 1883 8123 8555 8989];
  networking.firewall.allowedUDPPorts = [5683 config.services.tailscale.port 8555];

  services.devmon.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish.enable = true;
    publish.userServices = true;
  };
  boot.supportedFilesystems = ["ntfs"];
  boot.kernel.sysctl = {
    "net.ipv4.ip_unprivileged_port_start" = 0;
  };

  fileSystems."/mnt/data" = {
    device = "/dev/disk/by-uuid/7028A53628A4FC6A";
    fsType = "ntfs";
    options = [
      # If you don't have this options attribute, it'll default to "defaults"
      # boot options for fstab. Search up fstab mount options you can use
      "users" # Allows any user to mount and unmount
      "nofail" # Prevent system from failing if this drive doesn't mount,
      "rw"
      "uid=1000"
      "gid=501"
    ];
  };
}
