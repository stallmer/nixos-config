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
    rofi = "rofi";
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
      nrs = "sudo nixos-rebuild switch --flake ~/nixos-config";
      s = "kitten ssh";
    };
  };

  programs.atuin = {
    enable = true;
    settings = {
      auto_sync = true;
      sync_frequency = "5m";
      sync_address = "https://api.atuin.sh";
      search_mode = "fuzzy";
    };
  };

  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
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
    fzf
    nodejs
    gcc
    rofi
    thunar
    emacs
    bitwarden-desktop
    keepassxc
    nerd-fonts.jetbrains-mono
    tealdeer
    chromium
    mpv
    yt-dlp
  ];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 24;
  };

  services.udiskie = {
    enable = true;
  };
}
