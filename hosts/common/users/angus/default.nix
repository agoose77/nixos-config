# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{pkgs, ...}: {
  # users.mutableUsers = false;
  users.users = {
    angus = {
      isNormalUser = true;
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = ["networkmanager" "wheel" "media" "docker"];
      shell = pkgs.bash;
      uid = 1000;

      packages = with pkgs; [
        alacritty
        alejandra
        bat
        bash
        buildah
        delta
        dunst
        file
        fd
        fzf
        gimp
        git
        inkscape
        jq
        micro
        micromamba
        nushell
        podman
        oils-for-unix
        playerctl
        ripgrep
        slack
        unzip
        vulkan-loader
        vulkan-validation-layers
        vulkan-tools
        wget
        wofi
        wl-clipboard
        wlogout
        zip
        zoom-us
      ];
    };
  };
}
