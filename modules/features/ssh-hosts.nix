{
  flake.modules = {
    homeManager.ssh-hosts = {
      config,
      pkgs,
      ...
    }: {
      sops.secrets.mainsail-host = {
        sopsFile = ./secrets.yaml;
        key = "mainsail-host";
      };
      sops.secrets.mainsail-user = {
        sopsFile = ./secrets.yaml;
        key = "mainsail-user";
      };
      sops.secrets.mainsail-port = {
        sopsFile = ./secrets.yaml;
        key = "mainsail-port";
      };

      sops.templates."mainsail.conf" = let
        placeholder = config.sops.placeholder;
      in {
        content = ''
          Host mainsail
            HostName ${placeholder.mainsail-host};
            User ${placeholder.mainsail-user};
            Port ${placeholder.mainsail-port};
        '';
        mode = "444";
      };

      programs.ssh = {
        enable = true;
        includes = [config.sops.templates."mainsail.conf".path];
      };
    };
  };
}
