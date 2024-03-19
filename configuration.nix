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

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Locale
  time.timeZone = "Europe/London";
  i18n.defaultLocale = "en_GB.UTF-8";
  console.keyMap = "uk";

  # Graphics
  hardware.opengl.enable = true;

  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # USB mounting
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;

  # Login
  services.greetd = {
    enable = true;
    settings.default_session = {
      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
      user = "willow";
    };
  };

  # Desktop
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  # VM
  virtualisation.podman.enable = true;

  # Nix
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
  };

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
      
      imports = [
        ./dotfiles/sway/sway.nix
      ];

      # Programs requiring config
      programs = {

        # Shell
        nushell = {
          enable = true;
          configFile.text = builtins.readFile ./dotfiles/nu/config.nu;
          envFile.text = builtins.readFile ./dotfiles/nu/env.nu;
        };

        # Prompt
        starship = {
          enable = true;
          settings = {
            character.success_symbol = "[➜](bold green)";
            character.error_symbol = "[➜](bold red)";
          };
        };

        # Terminal emulator
        wezterm = {
          enable = true;
          extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
        };

        # Terminal navigation
        zoxide = {
          enable = true;
          enableNushellIntegration = true;
        };

        # File manager
        yazi = {
          enable = true;
          enableNushellIntegration = true;
        };

        # Editors
        helix = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile ./dotfiles/helix/helix.toml);
          languages = builtins.fromTOML (builtins.readFile ./dotfiles/helix/languages.toml);        };
        neovim = {
          enable = true;
          extraLuaConfig = builtins.readFile ./dotfiles/neovim/init.lua;
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

      # Other programs
      home.packages = with pkgs; [

        # Terminal
        neofetch
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

        # Dev
        gcc
        haskell.compiler.ghc94
        cabal-install
        cabal2nix
        pandoc
        texliveFull
        distrobox
        tokei

        # LSP
        haskell-language-server
        texlab
        lua-language-server

        # Fonts
        nerdfonts
        font-awesome
        jetbrains-mono
      ];


      # Try to remember why this is necessary
      fonts.fontconfig.enable = true;

      # Services
      services.kanshi.systemdTarget = "";

      services.gammastep = {
        enable = true;
        provider = "manual";
        latitude = 50.0;
        longitude = -14.0;
      };
    };
  };
}
# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
