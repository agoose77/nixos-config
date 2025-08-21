{
  virtualisation.oci-containers.containers.speedtest-tracker = {
    environment.TZ = "Europe/London";
    environment.SPEEDTEST_SCHEDULE = "0 */1 * * *";
    environment.APP_KEY = "base64:Xn3dUpdHB0Id07Q2KdLT5Qrf2MvgpSGkS6jL4cWXBWg=";
    ports = [
      "4898:80"
    ];
    image = "lscr.io/linuxserver/speedtest-tracker:1.6.6";
    volumes = [
      "/etc/speedtest-tracker/data:/config"
    ];
  };
}
