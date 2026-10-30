{
  flake.modules.homeManager.firefox = {
    lib,
    config,
    ...
  }: {
    programs.firefox = {
      enable = true;
      profiles.default = {
      };
      configPath = "${config.xdg.configHome}/mozilla/firefox";
      languagePacks = ["en-GB"];
      policies = {
        "RequestedLocales" = ["en-GB"];
        "AIControls.Default.Value" = "blocked";
      };
    };
    stylix.targets.firefox.profileNames = lib.mkIf config.stylix.enable ["default"];
  };
}
