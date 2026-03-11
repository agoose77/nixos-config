{
  flake.modules = {
    nixos._1password = {
      # Enable the 1Password CLI, this also enables a SGUID wrapper so the CLI can authorize against the GUI app
      programs._1password = {
        enable = true;
      };

      # Enable the 1Password GUI with myself as an authorized user for polkit
      programs._1password-gui = {
        enable = true;
        polkitPolicyOwners = ["angus"];
      };
    };
    homeManager._1password = {
      pkgs,
      lib,
      ...
    }: {
      programs.ssh.extraOptionOverrides.IdentityAgent = "~/.1password/agent.sock";
    };
  };
}
