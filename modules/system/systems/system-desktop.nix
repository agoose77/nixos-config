{inputs, ...}: {
  # import all essential nix-tools which are used in all modules of a specific class

  flake.modules.nixos.system-default = {
    imports = with inputs.self.modules.nixos; [
      system-minimal
      niri
      home-manager
      _1password
      spotify-connect
      sound
      stylix
      kdeconnect
    ];
  };

  flake.modules.homeManager.system-default = {
    imports = with inputs.self.modules.homeManager; [
      system-minimal
      niri
      stylix
      waybar
      jj
      firefox
      nixvim
      kitty
      fonts
      fuzzel
      notes
      playerctl
      notifications
      videoconf
      design
      kdeconnect
      no-global-kubeconfig
    ];
  };
}
