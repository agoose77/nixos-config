{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    jetbrains.pycharm-professional
    jetbrains.webstorm
  ];
  fonts.packages = with pkgs; [
    jetbrains-mono
    nerd-font-patcher
  ];
}
