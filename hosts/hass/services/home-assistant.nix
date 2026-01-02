{
  pkgs,
  lib,
  ...
}: let
  components = {
    myenergi = pkgs.fetchFromGitHub {
      owner = "CJNE";
      repo = "ha-myenergi";
      tag = "0.0.30";
      hash = "sha256-vy3I0MLNErz6Y/hoH7Jv/Mpqtg4E2i8cQkGGWpTyfhs=";
    };
    frigate = pkgs.fetchFromGitHub {
      owner = "blakeblackshear";
      repo = "frigate-hass-integration";
      tag = "v5.11.0";
      hash = "sha256-LzrIvHJMB6mFAEfKoMIs0wL+xbEjoBIx48pSEcCHmg4=";
    };
    # Requires profile from another GitHub repo
    homeconnect_ws = pkgs.fetchFromGitHub {
      owner = "chris-mc1";
      repo = "homeconnect_local_hass";
      rev = "2da91a43678098d9267eea1d740658fe35d7b0ad";
      hash = "sha256-Xq7dXKPhSQTirMUixQ8eGqNZ+0drlZOXlTUXRZqXv5w=";
    };
    climate_template = pkgs.fetchFromGitHub {
      owner = "jcwillox";
      repo = "hass-template-climate";
      tag = "v1.3.0";
      hash = "sha256-hWYYY0kt/RfdCyNR3skiYOyyQ7KF35Xbh8NczIDzr58=";
    };
    octopus_energy = pkgs.fetchFromGitHub {
      owner = "BottlecapDave";
      repo = "HomeAssistant-OctopusEnergy";
      tag = "v17.1.1";
      hash = "sha256-rn8wCGUYisLgr61Cd2qaQGfSiAtjKMo2wG/AotEXknE=";
    };
    spook = pkgs.applyPatches {
      name = "spook-patched";
      src = pkgs.fetchFromGitHub {
        owner = "frenck";
        repo = "spook";
        tag = "v4.0.1";
        hash = "sha256-0IihrhATgraGmuMRnrbGTUrtlXAR+CooENSIKSWIknY=";
      };
      postPatch = ''
        substituteInPlace \
          custom_components/spook/manifest.json --replace-fail \
          0.0.0 \
          4.0.1
      '';
    };
    tplink_router = pkgs.fetchFromGitHub {
      owner = "AlexandrErohin";
      repo = "home-assistant-tplink-router";
      tag = "v2.13.0";
      hash = "sha256-2yhoBIU2NMLhAvezB82/gs+A0ZVVsMenvOR1HyU1PEM=";
    };
  };
in {
  # Open shelly port
  networking.firewall.allowedUDPPorts = [5683];
  networking.firewall.allowedTCPPorts = [8123];

  virtualisation.oci-containers.containers = {
    home-assistant = {
      environment.TZ = "Europe/London";
      # This fixes a bug
      environment.PYTHONPATH = "/usr/local/lib/python3.13:/config/deps";
      image = "ghcr.io/home-assistant/home-assistant:2025.12.5"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
        "--cap-add=NET_RAW"
        "--mount=type=tmpfs,destination=/config/www/snapshots"
        #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
      ];
      volumes =
        [
          "/run/dbus:/run/dbus:ro"
          "/etc/home-assistant:/config"
          "${components.spook}/custom_components/spook/integrations/spook_inverse:/config/custom_components/spook_inverse"
        ]
        ++ lib.attrsets.mapAttrsToList (name: drv: "${drv}/custom_components/${name}:/config/custom_components/${name}") components;
    };
    matter-server = {
      image = "ghcr.io/matter-js/python-matter-server:stable"; # Warning: if the tag does not change, the image will not be updated
      extraOptions = [
        "--network=host"
        "--security-opt=apparmor=unconfined"
      ];
      volumes = [
        "/run/dbus:/run/dbus:ro"
        "/etc/matter-server:/data"
      ];
    };
  };
}
