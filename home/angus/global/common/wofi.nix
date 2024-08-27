{pkgs, ...}: {
  xdg.desktopEntries."wofi-emoji" = {
    name = "wofi-emoji";
    genericName = "Emoji Picker";
    exec = "wofi-emoji";
    terminal = false;
    categories = ["Application"];
  };

  home.packages = [
    pkgs.wofi-emoji
  ];
}
