# `agoose77`'s NixOS Config

This repo contains my NixOS configuration, as I figure out how this thing works!

Make no mistake, this is probably not best practice; I just need to get things working again! And, crucially, avoid needing to switch to Nix again!

## Bootstrap

- [Install git](https://nixos.wiki/wiki/git), if you haven't already.
- Create a repository for your config, for example:
```bash
cd ~/Documents
git init nix-config
cd nix-config
```
- Make sure you're running Nix 2.4+, and opt into the experimental `flakes` and `nix-command` features:
```bash
# Should be 2.4+
nix --version
export NIX_CONFIG="experimental-features = nix-command flakes"
```
- Enter dev shell
```bash
nix develop .
```
- (New hosts) Generate `id_ed25519` key and store in `/etc/ssh/ssh_host_ed25519.*` paths.
- Run `sudo nixos-rebuild switch --flake .#$(hostname)`

## Usage

- Run `sudo nixos-rebuild switch --flake .#$(hostname)` to apply your system
  configuration.
    - If you're still on a live installation medium, run `nixos-install --flake
      .#hostname` instead, and reboot.
- Run `home-manager switch --flake .#$(id -un)@$(hostname)` to apply your home
  configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.
