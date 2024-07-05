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
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
    transmission
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

  # FIXME: Add the rest of your current configuration

  # TODO: Set your hostname
  networking = {
    hostName = "home-assistant";
    networkmanager.enable = true;
    interfaces."enp4s0".macAddress = "20:47:47:79:c5:7d";
  };
  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  # TODO: i18n for lC_

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

  services.transmission.settings = {
    download-dir = "${config.services.transmission.home}/Downloads";
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";

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
        image = "ghcr.io/home-assistant/home-assistant:stable"; # Warning: if the tag does not change, the image will not be updated
        extraOptions = [
          "--network=host"
          "--cap-add=NET_RAW"
          #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
        ];
        volumes = [
          "/etc/home-assistant:/config"
        ];
      };
      # VSCode Server
      containers.code-server = {
        environment.TZ = "Europe/London";
        image = "lscr.io/linuxserver/code-server:latest";
        volumes = [
          "/etc/home-assistant:/etc/home-assistant"
          "/etc/code-server/config:/config"
        ];
        ports = [
          "8443:8443"
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
      };
    };
    containers.enable = true;
  };

  services.jellyfin = {
    enable = true;
    openFirewall = true;
    group = "media";
  };

  #services.xserver.videoDrivers = ["nvidia"];
  #hardware.opengl = {
  #  enable = true;
  #  driSupport = true;
  #  driSupport32Bit = true;
  #  # For better video playback
  #  extraPackages = with pkgs; [nvidia-vaapi-driver];
  #};#

  #hardware.nvidia = {
  #  modesetting.enable = true;
  #  open = false;
  #  nvidiaSettings = true;
  #  package = config.boot.kernelPackages.nvidiaPackages.stable;
  #};

  hardware.pulseaudio.enable = false;

  sound.enable = true;
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

  networking.firewall.allowedTCPPorts = [80 443 8123];
  networking.firewall.allowedUDPPorts = [5683];
  services.caddy = {
    enable = true;

    # Auto-HTTPS remote routing
    virtualHosts."agoose77.ddns.net".extraConfig = ''
      reverse_proxy localhost:8123

      redir /jellyfin /jellyfin/
      reverse_proxy /jellyfin/* localhost:8096

      # reverse_proxy /vscode/* localhost:8443 -- don't do this!
    '';

    # For HTTP-only local routing
    virtualHosts.":80".extraConfig = ''
      reverse_proxy localhost:8123

      redir /jellyfin /jellyfin/
      reverse_proxy /jellyfin/* 127.0.0.1:8096

      redir /vscode /vscode/
      reverse_proxy /vscode/* localhost:8443
    '';
  };

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
