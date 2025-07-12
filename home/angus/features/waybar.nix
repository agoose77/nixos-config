{...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      # Primary bar
      primary = {
        layer = "top";
        position = "top";
        height = 30;
        modules-left = ["hyprland/workspaces" "hyprland/submap"];
        modules-center = ["hyprland/window"];
        modules-right = ["cpu" "memory" "disk" "clock" "pulseaudio" "battery" "tray"];
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
          tooltip-format = "{capacity}% ({time})";
          onclick = "";
        };
        clock = {
          timezone = "";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%d-%m-%Y}";
        };
        cpu = {
          format = "{usage}% ";
          tooltip = false;
        };
        memory = {
          format = "{}% ";
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
          format = "{percentage_used}% 󰉉";
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
