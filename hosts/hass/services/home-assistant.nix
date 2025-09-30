{pkgs, ...}: let
  myenergiComponent = pkgs.fetchFromGitHub {
    owner = "CJNE";
    repo = "ha-myenergi";
    tag = "0.0.30";
    hash = "sha256-vy3I0MLNErz6Y/hoH7Jv/Mpqtg4E2i8cQkGGWpTyfhs=";
  };
  frigateComponent = pkgs.fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v5.9.4";
    hash = "sha256-LzrIvHJMB6mFAEfKoMIs0wL+xbEjoBIx48pSEcCHmg4=";
  };
  climateComponent = pkgs.fetchFromGitHub {
    owner = "jcwillox";
    repo = "hass-template-climate";
    tag = "v1.3.0";
    hash = "sha256-hWYYY0kt/RfdCyNR3skiYOyyQ7KF35Xbh8NczIDzr58=";
  };
  octopusComponent = pkgs.fetchFromGitHub {
    owner = "BottlecapDave";
    repo = "HomeAssistant-OctopusEnergy";
    tag = "v16.3.1";
    hash = "sha256-rn8wCGUYisLgr61Cd2qaQGfSiAtjKMo2wG/AotEXknE=";
  };
  spookComponent = pkgs.fetchFromGitHub {
    owner = "frenck";
    repo = "spook";
    tag = "v4.0.1";
    hash = "sha256-0IihrhATgraGmuMRnrbGTUrtlXAR+CooENSIKSWIknY=";
  };
  tplinkComponent = pkgs.fetchFromGitHub {
    owner = "AlexandrErohin";
    repo = "home-assistant-tplink-router";
    tag = "v2.9.0";
    hash = "sha256-2yhoBIU2NMLhAvezB82/gs+A0ZVVsMenvOR1HyU1PEM=";
  };
in {
  # Open shelly port
  networking.firewall.allowedUDPPorts = [5683];
  networking.firewall.allowedTCPPorts = [8123];

  virtualisation.oci-containers.containers.home-assistant = {
    environment.TZ = "Europe/London";
    # This fixes a bug
    environment.PYTHONPATH = "/usr/local/lib/python3.13:/config/deps";
    image = "ghcr.io/home-assistant/home-assistant:2025.9.3"; # Warning: if the tag does not change, the image will not be updated
    extraOptions = [
      "--network=host"
      "--cap-add=NET_RAW"
      "--mount=type=tmpfs,destination=/config/www/snapshots"
      #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
    ];
    volumes = [
      "/run/dbus:/run/dbus:ro"
      "/etc/home-assistant:/config"
      "${myenergiComponent}/custom_components/myenergi:/config/custom_components/myenergi"
      "${frigateComponent}/custom_components/frigate:/config/custom_components/frigate"
      "${climateComponent}/custom_components/climate_template:/config/custom_components/climate_template"
      "${octopusComponent}/custom_components/octopus_energy:/config/custom_components/octopus_energy"
      "${spookComponent}/custom_components/spook:/config/custom_components/spook"
      "${spookComponent}/custom_components/spook/integrations/spook_inverse:/config/custom_components/spook_inverse"
      "${tplinkComponent}/custom_components/tplink_router:/config/custom_components/tplink_router"
    ];
  };
}
