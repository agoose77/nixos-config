{
  lib,
  config,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
    };
  };
  stylix.targets.firefox.profileNames = lib.mkIf config.stylix.enable ["default"];
}
