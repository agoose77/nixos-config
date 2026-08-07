{
  inputs,
  lib,
  config,
  ...
}: {
  flake.modules.nixos.impermanence = {
    imports = [inputs.impermanence.nixosModules.impermanence];

    environment.persistence = {
      "/persist" = {
        files = [
          "/etc/machine-id"
        ];
        directories = [
          "/var/lib/fprint"
          "/var/lib/systemd"
          "/var/lib/nixos"
          "/var/log"
          "/srv"
        ];
      };
    };

    # From https://github.com/Misterio77/Foundry/blob/1bfb3c687d55f2d746c99e0a5e6435e6408d3aa8/hosts/nixos/common/global/optin-persistence.nix#L2
    # See: https://github.com/nix-community/impermanence/issues/254
    systemd.tmpfiles.rules = [
      "d /persist/var/lib/private 0700 root root -"
      "e /var/lib/private 0700 root root -"
    ];
    systemd.services."systemd-tmpfiles-resetup".serviceConfig.RemainAfterExit = lib.mkForce false;
    programs.fuse.userAllowOther = true;

    # Persist user homes
    system.activationScripts.persistent-dirs.text = let
      mkHomePersist = user:
        lib.optionalString user.createHome ''
          mkdir -p /persist/${user.home}
          chown ${user.name}:${user.group} /persist/${user.home}
          chmod ${user.homeMode} /persist/${user.home}
        '';
      users = lib.attrValues config.users.users;
    in
      lib.concatLines (map mkHomePersist users);
  };
}
