{ config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  ################################
  #### SYSTEM                  ###
  ################################

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs" ];

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
#  services.xserver.xkb.layout = "gb";
#  console.keyMap = "uk";

  # Graphics
  hardware.graphics.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Desktop
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.displayManager.gdm.wayland = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Printing
  services.printing.enable = true;

  # VM
  virtualisation.podman.enable = true;

  # Nix
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 10d";

  # Users
  users.users.willow = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "input" "networkmanager" ];
  };


  ################################
  #### Home Manager (user)     ###
  ################################

  home-manager = {
    users.willow = {
      home = {
        username = "willow";
        homeDirectory = "/home/willow";
        stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      };

      # Programs requiring config
      programs = {

        # Shell
        # nushell = {
        #   enable = true;
        #   configFile.text = builtins.readFile ./dotfiles/nu/config.nu;
        #   envFile.text = builtins.readFile ./dotfiles/nu/env.nu;
        # };
        fish = {
          enable = true;
          interactiveShellInit = builtins.readFile ./dotfiles/fish/shellInit.fish;
        };

        # Terminal emulator
        wezterm = {
          enable = true;
          extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
        };

        # Terminal navigation
        zoxide = {
          enable = true;
          enableFishIntegration = true;
        };

        # File manager
        yazi = {
          enable = true;
          enableFishIntegration = true;
          settings.opener = {
            edit = [
              {
                run = "nvim \"$@\"";
                block = true;
                for = "unix";
              }
            ];
          };
        };

        # Editors
        helix = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile ./dotfiles/helix/helix.toml);
          languages = builtins.fromTOML (builtins.readFile ./dotfiles/helix/languages.toml);
        };
        neovim = {
          enable = true;
          extraLuaConfig = builtins.readFile ./dotfiles/neovim/init.lua;
        };
        emacs = {
          enable = true;
          package = pkgs.emacs;  # replace with pkgs.emacs-gtk, or a version provided by the community overlay if desired.
          extraPackages = epkgs: [ epkgs.dracula-theme epkgs.evil epkgs.haskell-mode ];
          extraConfig = builtins.readFile ./dotfiles/emacs/init.el;
        };

        # Git
        git = {
          enable = true;
          userName  = "nurho";
          userEmail = "12024497+nurho@users.noreply.github.com";
        };

        # Direnv
        direnv = {
          enable = true;
          enableNushellIntegration = true;
          nix-direnv.enable = true;
        };
      };

      # Gnome settings
      dconf.settings = import ./dotfiles/gnome/gnome.nix;

      # Other programs
      home.packages = with pkgs; [
        # Terminal
        hyfetch
        bottom
        powertop
        wget
        killall
        tree
        tree-sitter
        rclone
        unzip
        visidata
        ouch
        wl-clipboard
        wally-cli

        # Windowed
        pavucontrol
        networkmanagerapplet
        firefox
        palemoon-bin
        imv
        mpv
        zathura
        gimp
        pcmanfm
        libreoffice
        lm_sensors
        signal-desktop
        gnome.dconf-editor

        # Dev
        gcc
        texliveFull
        distrobox
        tokei

        # LSP
        texlab
        lua-language-server

        # Gnome Extensions
        gnomeExtensions.workspaces-indicator-by-open-apps

        # Fonts
        nerdfonts
        font-awesome
        jetbrains-mono
      ];

      # Try to remember why this is necessary
      fonts.fontconfig.enable = true;
    };
  };
}
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
