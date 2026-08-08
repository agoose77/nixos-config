{
  flake.modules.nixos.hass-home-assistant = {
    pkgs,
    lib,
    ...
  }: let
    components = {
      openwrt = pkgs.fetchFromGitHub {
        owner = "FaserF";
        repo = "ha-openwrt";
        tag = "v2.4.2";
        hash = "sha256-OMVTsdYIZ0tCMOkZ7FpdA+TmyyMD0SmkQbVQoahJZXY=";
      };
      myenergi = pkgs.fetchFromGitHub {
        owner = "CJNE";
        repo = "ha-myenergi";
        tag = "0.2.0";
        hash = "sha256-ke3hqhchMopTRcUDTdOy5ZwkBkMNxh7OjyYoPqW2px8=";
      };
      frigate = pkgs.fetchFromGitHub {
        owner = "blakeblackshear";
        repo = "frigate-hass-integration";
        tag = "v5.15.4";
        hash = "sha256-xckHpwKujlWJ0M/fDlCU96WocMIlMk37+TwmY8iEnNo=";
      };
      # Requires profile from another GitHub repo
      homeconnect_ws = pkgs.fetchFromGitHub {
        owner = "agoose77";
        repo = "homeconnect_local_hass";
        rev = "4f6a3d27243d387ffea0efb2444da833fd4f8296";
        hash = "sha256-+KBoQLItNmhVH8wWqJMEFEzfVjggp4fbvQza5Eeo/+s=";
      };
      climate_template = pkgs.fetchFromGitHub {
        owner = "jcwillox";
        repo = "hass-template-climate";
        tag = "v1.3.0";
        hash = "sha256-hWYYY0kt/RfdCyNR3skiYOyyQ7KF35Xbh8NczIDzr58=";
      };
      bermuda = pkgs.fetchFromGitHub {
        owner = "agittins";
        repo = "bermuda";
        tag = "v0.8.7";
        hash = "sha256-UY4Cd0yt7yAbsYHr+KsLUan3dJSv80hhEPRmoy+8nO4=";
      };
      octopus_energy = pkgs.fetchFromGitHub {
        owner = "BottlecapDave";
        repo = "HomeAssistant-OctopusEnergy";
        tag = "v18.3.2";
        hash = "sha256-KSnpebEUzp25PsBMFqCajdnTINk51hdswmV9rGtG+3Q=";
      };
      tuya_local = pkgs.fetchFromGitHub {
        owner = "make-all";
        repo = "tuya-local";
        tag = "2026.7.0";
        hash = "sha256-XShC71yQ6l0fYmlx0nR1WHE4ku95ghZ2RWCfzDDJKfc=";
      };
      spook = let
        version = "4.0.1";
      in
        pkgs.applyPatches {
          name = "spook-patched";
          src = pkgs.fetchFromGitHub {
            owner = "frenck";
            repo = "spook";
            tag = "v${version}";
            hash = "sha256-0IihrhATgraGmuMRnrbGTUrtlXAR+CooENSIKSWIknY=";
          };
          postPatch = ''
            substituteInPlace \
              custom_components/spook/manifest.json --replace-fail \
              0.0.0 \
              ${version}
          '';
        };
      tplink_router = pkgs.fetchFromGitHub {
        owner = "AlexandrErohin";
        repo = "home-assistant-tplink-router";
        tag = "v2.19.0";
        hash = "sha256-YAUCcX5qdlJOD8qFR7I/B7bF4trTSy5K3Dmmwt5AmEs=";
      };
    };
    webResources = {
      advancedCameraCard = pkgs.fetchzip {
        url = "https://github.com/dermotduffy/advanced-camera-card/releases/download/v7.27.4/advanced-camera-card.zip";
        stripRoot = false;
        hash = "sha256-E1ejO/ZLaw4AUbj06jEiFdCjoM30PJQd1k57CYSjzUo=";
      };
      miniGraphCard = pkgs.fetchurl {
        url = "https://github.com/kalkih/mini-graph-card/releases/download/v0.13.0/mini-graph-card-bundle.js";
        hash = "sha256-TYuYbzzWk8D3dx0vVXQAi8OcRey0UK7AZ5BhUL4t+r0=";
      };
      materialYouTheme = pkgs.fetchFromGitHub {
        owner = "Nerwyn";
        repo = "material-you-theme";
        rev = "076931b584edf70a1536999d890aeecb395b1296";
        hash = "sha256-BN/EZYZTgxAqdm2wTt4witxpwcpFewuetMrb6bio/LY=";
      };
      materialYouUtilities = pkgs.fetchFromGitHub {
        owner = "Nerwyn";
        repo = "material-you-utilities";
        rev = "3147d9c5859a92afa991a1b6a5d6ca9573e7138f";
        hash = "sha256-9eOn5E4lYzhfZSl7dmb3UNEkgU+hv7UFfmh6r6IX13M=";
      };
    };
  in {
    # Open shelly port
    networking.firewall.allowedUDPPorts = [5683];
    networking.firewall.allowedTCPPorts = [8123];

    virtualisation.oci-containers.containers = let
      # For backups, we need to avoid mounting anything
      isBackup = false;
    in {
      home-assistant = {
        environment.TZ = "Europe/London";
        # This fixes a bug
        environment.PYTHONPATH = "/usr/local/lib/python3.13:/config/deps";
        image = "ghcr.io/home-assistant/home-assistant:2026.7.4 "; # Warning: if the tag does not change, the image will not be updated
        extraOptions =
          [
            "--network=host"
            "--cap-add=NET_RAW"
            "--cap-add=NET_ADMIN"
          ]
          #"--device=/dev/ttyACM0:/dev/ttyACM0"  # Example, change this to match your own hardware
          ++ lib.optionals (!isBackup) [
            "--mount=type=tmpfs,destination=/config/www/snapshots"
          ];

        volumes =
          [
            "/run/dbus:/run/dbus:ro"
            "/etc/home-assistant:/config"
          ]
          ++ lib.optionals (!isBackup) (["${components.spook}/custom_components/spook/integrations/spook_inverse:/config/custom_components/spook_inverse"]
            ++ lib.attrsets.mapAttrsToList (name: drv: "${drv}/custom_components/${name}:/config/custom_components/${name}") components)
          ++ lib.optionals (!isBackup) [
            "${webResources.advancedCameraCard}/dist:/config/www/advancedCameraCard/"
            "${webResources.miniGraphCard}:/config/www/miniGraphCard/mini-graph-card-bundle.js"
            "${webResources.materialYouTheme}:/config/www/materialYouTheme/"
            "${webResources.materialYouUtilities}:/config/www/materialYouUtilities/"
            "${webResources.materialYouTheme}/themes/material_you.yaml:/config/themes/material_you.yaml"
          ];
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
  };
}
