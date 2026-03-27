{ config, pkgs, ... }:
let
  dotfiles = "${config.home.homeDirectory}/nixos-config/config";
  create_symlink = path: config.lib.file.mkOutOfStoreSymlink path;

  # Standard .config/directory
  configs = {
    emacs = "emacs";
    tmux = "tmux";
    tealdeer = "tealdeer";
    hypr = "hypr";
    kitty = "kitty";
    waybar = "waybar";
  };
in
{
  home.username = "stephen";
  home.homeDirectory = "/home/stephen";
  home.stateVersion = "25.11";
  programs.git.enable = true;
  programs.bash = {
    enable = true;
    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config#carbon";
    };
  };

  xdg.configFile = builtins.mapAttrs
    (name: subpath: {
      source = create_symlink "${dotfiles}/${subpath}";
      recursive = true;
    })
    configs;

  home.packages = with pkgs; [
    neovim
    ripgrep
    nil
    nixpkgs-fmt
    nodejs
    gcc
    rofi
    thunar
    emacs
    bitwarden-desktop
    nerd-fonts.jetbrains-mono
    tealdeer
    chromium
  ];
}
