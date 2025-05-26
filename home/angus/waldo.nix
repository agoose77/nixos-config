{pkgs, ...}: {
  imports = [./global];
  monitors = [
    {
      name = "DP-1";
      width = 1920;
      height = 1200;
      workspace = "1";
      primary = true;
    }
    {
      name = "DP-2";
      width = 1920;
      height = 1200;
      position = "auto-down";
      workspace = "2";
    }
  ];
}
