{
  flake.modules.nixos.throttlestop = {
    pkgs,
    lib,
    ...
  }: {
    systemd.services.throttlestop = {
      serviceConfig.Type = "oneshot";
      script = ''
        ${lib.getExe pkgs.local.throttlestop} temperature "{\"offset\": 20}"
        ${lib.getExe pkgs.local.throttlestop} voltage "{\"cache\": -149, \"cpu\": -149}"
      '';
    };
    systemd.timers.throttlestop = {
      wantedBy = ["timers.target"];
      partOf = ["throttlestop.service"];
      timerConfig = {
        OnCalendar = "*-*-* *:30:00";
        Unit = "throttlestop.service";
      };
    };
  };
}
