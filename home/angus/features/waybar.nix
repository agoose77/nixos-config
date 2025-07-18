{...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
             * {
             border: none;
             border-radius: 0;
             /* `otf-font-awesome` is required to be installed for icons */
             font-family: Noto Sans, Material Design Icons;
             min-height: 20px;
      font-size: 10pt;
      font-weight: 500;
         }

         window#waybar {
             background: transparent;
         }

         window#waybar.hidden {
             opacity: 0.2;
         }

         #workspaces {
             margin-right: 8px;
             border-radius: 10px;
             transition: none;
             background: #383c4a;
         }

         #workspaces button {
             transition: none;
             color: #7c818c;
             background: transparent;
             padding: 5px;
         }

         #workspaces button.persistent {
             color: #7c818c;
         }

         /* https://github.com/Alexays/Waybar/wiki/FAQ#the-workspace-buttons-have-a-strange-hover-effect */
         #workspaces button:hover {
             transition: none;
             box-shadow: inherit;
             text-shadow: inherit;
             border-radius: inherit;
             color: #383c4a;
             background: #7c818c;
         }

         #workspaces button.visible {
             color: white;
         }
         #clock {
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px 10px 10px 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         #pulseaudio {
             margin-right: 8px;
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         #pulseaudio.muted {
             background-color: #90b1b1;
             color: #2a5c45;
         }

         #memory {
             margin-right: 8px;
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         #cpu {
             margin-right: 8px;
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         #disk {
             margin-right: 8px;
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         #temperature {
             margin-right: 8px;
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         #temperature.critical {
             background-color: #eb4d4b;
         }

              #battery {
             margin-right: 8px;
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         #battery.charging {
             color: #ffffff;
             background-color: #26A65B;
         }

         #battery.warning:not(.charging) {
             background-color: #ffbe61;
             color: black;
         }

         #battery.critical:not(.charging) {
             background-color: #f53c3c;
             color: #ffffff;
             animation-name: blink;
             animation-duration: 0.5s;
             animation-timing-function: linear;
             animation-iteration-count: infinite;
             animation-direction: alternate;
         }

         #tray {
             padding-left: 16px;
             padding-right: 16px;
             border-radius: 10px;
             transition: none;
             color: #ffffff;
             background: #383c4a;
         }

         @keyframes blink {
             to {
                 background-color: #ffffff;
                 color: #000000;
             }
         }

    '';
    settings = {
      # Primary bar
      primary = {
        layer = "top";
        position = "top";
        height = 30;
        margin = "10 20";
        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "disk" "pulseaudio" "battery" "tray"];
        battery = {
          interval = 10;
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          format = "{icon}";
          format-charging = "󰂄";
          format-alt = "{capacity}% ({time})";
          tooltip-format = "{capacity}% ({time})";
          onclick = "";
        };
        clock = {
          timezone = "";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format = "{:%a, %d %b, %I:%M %p}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{used}GiB ";
          format-alt = "{}% ";
        };
        temperature = {
          # "thermal-zone": 2;
          # "hwmon-path": "/sys/class/hwmon/hwmon2/temp1_input";
          critical-threshold = 80;
          # "format-critical": "{temperatureC}°C {icon}";
          format = "{temperatureC}°C {icon}";
          format-icons = ["" "" ""];
        };
        disk = {
          format = "{percentage_used}% ";
        };
        pulseaudio = {
          # "scroll-step": 1, // %, can be a float
          format = "{volume}% {icon} {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        "hyprland/submap" = {
          format = "✌️ {}";
          max-length = 80;
          tooltip = false;
        };
        "hyprland/workspaces" = {
          on-click = "activate";
          disable-scroll = true;
          all-outputs = false;
          # format: "{icon}";
          # format-icons = {
          #   "1": "♈ Emacs";
          #   "2": "♉ Term";
          #   "3": "♊ Web";
          #   "4": "♋ Other";
          #   "5": "♌ Game";
          #   "6": "♍ Social";
          #   "7": "♎ Service";
          #   "8": "♏ Debug";
          #   "9": "♐ Temp";
          # };
        };
      };
    };
  };
}
