# `agoose77`'s NixOS Config

This repo contains my NixOS configuration, as I figure out how this thing works!

Make no mistake, this is probably not best practice; I just need to get things working again! And, crucially, avoid needing to switch to Nix again!

# What this provides
  - Basic boilerplate for adding overlays
    (under `overlay`). Accessible on your system, home config, as well as `nix
    build .#package-name`.
  - Boilerplate for custom NixOS (`modules/nixos`) and home-manager
    (`modules/home-manager`) modules
  - NixOS and home-manager configurations from minimal, and they should
    also use your overlays and custom packages right out of the box.

# Getting started

Assuming you have a basic NixOS booted up (either live or installed, anything
works). [Here's a link to the latest NixOS downloads, just for
you](https://nixos.org/download#download-nixos).

Alternatively, you can totally use `nix` and `home-manager` on your existing
distro (or even on Darwin). [Install nix](https://nixos.org/download.html#nix)
and follow along (just ignore the `nixos-*` commands).

## The repo

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
- Get the template:
```bash
# For standard version
nix flake init -t github:misterio77/nix-starter-config#standard
```
- If you want to use NixOS: add stuff you currently have on `/etc/nixos/` to
  `nixos` (usually `configuration.nix` and `hardware-configuration.nix`, when
  you're starting out).
    - The included file has some options you might want, specially if you don't
      have a configuration ready. Make sure you have generated your own
      `hardware-configuration.nix`; if not, just mount your partitions to
      `/mnt` and run: `nixos-generate-config --root /mnt`.
- If you want to use home-manager: add your stuff from `~/.config/nixpkgs`
  to `home-manager` (probably `home.nix`).
  - The included file is also a good starting point if you don't have a config
    yet.
- Take a look at `flake.nix`, making sure to fill out anything marked with
  FIXME (required) or TODO (usually tips or optional stuff you might want)
- `git add` and `git push` your changes! Or at least copy them somewhere if
  you're on a live medium.

## Usage

- Run `sudo nixos-rebuild switch --flake .#hostname` to apply your system
  configuration.
    - If you're still on a live installation medium, run `nixos-install --flake
      .#hostname` instead, and reboot.
- Run `home-manager switch --flake .#username@hostname` to apply your home
  configuration.
  - If you don't have home-manager installed, try `nix shell nixpkgs#home-manager`.

And that's it, really! You're ready to have fun with your configurations using
the latest and greatest nix3 flake-enabled command UX.
