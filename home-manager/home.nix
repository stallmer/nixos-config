# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors):
    # inputs.nix-colors.homeManagerModule

    # You can also split up your configuration and import pieces of it here:
    # ./nvim.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
  };

  # TODO: Set your username
  home = {
    username = "stephen";
    homeDirectory = "/home/stephen";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    stow
    fish
    starship
    neovim
    emacs
    btop
    bat
    thunderbird
    mpv
    yt-dlp
    vscode
    ptyxis
    tealdeer
    syncthing
    nextcloud-client
    fzf
    fd
    bat
    flameshot
    gnome.dconf-editor

    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  services.syncthing.enable = true;

  programs.fish = {
    enable = true;
    plugins = [
      { name = "z"; src = pkgs.fishPlugins.z.src; }
      { name = "fzf"; src = pkgs.fishPlugins.fzf-fish.src; }
    ];
  };

  programs.starship = {
    enable = true;
  };

  programs.firefox = {
    enable = true;
    profiles.stephen = {
      extensions = with inputs.firefox-addons.packages."x86_64-linux"; [
        ublock-origin
        tridactyl
        bitwarden
        org-capture
        sponsorblock
        dearrow
      ];
    };
  };

  # Configure gnome settings and keybindings.
  dconf.settings = {
    # This sections requires the pop-shell gnome extension.
    "org/gnome/shell/extensions/pop-shell" = {
      # Show border around window with focus
      active-hint = true;
      tile-by-default = true;

      # Shortcuts to move focus
      tile-mode-left = ["<Super>h"];
      tile-move-down = ["<Super>j"];
      tile-move-up = ["<Super>k"];
      tile-move-right = ["<Super>l"];
      
      # Shortcuts to move windows
      tile-move-left-global = ["<Super><Shift>h"];
      tile-move-down-global = ["<Super><Shift>j"];
      tile-move-up-global = ["<Super><Shift>k"];
      tile-move-right-global = ["<Super><Shift>l"];
    };

    # Keybinds for workspace movement and windows movement between workspaces
    "org/gnome/desktop/wm/keybindings" = {
      # Move between workspaces
      switch-to-workspace-1 = ["<Super>1"];
      switch-to-workspace-2 = ["<Super>2"];
      switch-to-workspace-3 = ["<Super>3"];
      switch-to-workspace-4 = ["<Super>4"];

      # Move windows between workspaces
      move-to-workspace-1 = ["<Super><Shift>1"];
      move-to-workspace-2 = ["<Super><Shift>2"];
      move-to-workspace-3 = ["<Super><Shift>3"];
      move-to-workspace-4 = ["<Super><Shift>4"];
    };

    # Custom keybind to enable caffeine
    "org/gnome/shell/extensions/caffeine" = {
      toggle-shortcut = ["<Shift><Control><Alt>F12"];
    };

    # Custom keybind to launch emacsclient
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom5" = {
      binding = "<Shift><Control><Alt>e";
      command = "emacsclient -cn -a ''";
      name = "Emacsclient";
    };
    # Custom keybind to launch org-capture
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom6" = {
      binding = "<Shift><Control><Alt>c";
      command = "emacsclient -cn -a '' -e '(org-capture)'";
      name = "Emacsclient Org-caApture";
    };
    # Custom keybind to flameshot for screenshots
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom9" = {
      binding = "Print";
      command = "flameshot gui";
      name = "Launch flameshot";
    };
  };


  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
