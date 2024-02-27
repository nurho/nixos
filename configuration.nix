{ config, lib, pkgs, inputs, outputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ./hardware-configuration.nix
  ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  # Proxy
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Locale
  time.timeZone = "Europe/London";
  services.xserver.xkb.layout = "gb";
  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
   # useXkbConfig = true; # use xkb.options in tty.
  };

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
  #### Home Manager (user config)#
  ################################

  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users.willow = {
      home = {
        username = "willow";
        homeDirectory = "/home/willow";
        stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      };
      
      imports = [
        ./ugly.nix
      ];

      # Programs requiring config
      programs = {

        # Bar
        waybar = {
          enable = true;
          style = ./dotfiles/waybar/style.css;
        };

        # Shell
        nushell = {
          enable = true;
          configFile.text = builtins.readFile ./dotfiles/nu/config.nu;
          envFile.text = builtins.readFile ./dotfiles/nu/env.nu;
        };
#        carapace = {
#          enable = true;
#          enableNushellIntegration = true;
#        };

        # Prompt
        starship = {
          enable = true;
          settings = {
            character = { 
              success_symbol = "[➜](bold green)";
              error_symbol = "[➜](bold red)";
            };
          };
        };

        # Terminal emulator
        wezterm = {
          enable = true;
          extraConfig = builtins.readFile ./dotfiles/wezterm/wezterm.lua;
        };

        # File manager
        yazi = {
          enable = true;
          enableNushellIntegration = true;
        };

        # Editor
        helix = {
          enable = true;
          settings = builtins.fromTOML (builtins.readFile ./dotfiles/helix/helix.toml);
        };

        # Git
        git = {
          enable = true;
          userName  = "nurho";
          userEmail = "willowisawisp@gmail.com";
        };
      };

#      programs.zsh = {
#        enable = true;
#        #autosuggestions.enable = true;
#        #zsh-autoenv.enable = true;
#        syntaxHighlighting.enable = true;
#        dotDir = "nixos/dotfiles/zsh";
#        oh-my-zsh = {
#          enable = true;
#          theme = "agnoster";
#          plugins = [
#            "git"
#            "history"
#            "vi-mode"
#            "rust"
#            "zsh-autocorrections"
#            "zsh-autoenv"
#          ];
#        };
#      };

      # Other programs
      home.packages = with pkgs; [
        # Sway
        dbus # make dbus-update-activation-environment available in the path
        wayland # window system
        xdg-utils # for opening default programs when clicking links
        glib # gsettings
        dracula-theme # gtk theme
        gnome3.adwaita-icon-theme # default gnome cursors
        waybar # bar
        swaylock-effects # lock screen
        swayidle # idle monitor
        brightnessctl # brightness
        grim # screenshots
        slurp # screenshots
        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
        bemenu # menu
        mako # notifications
        wdisplays # tool to configure displays
        wlogout # logout menu
        gtk-layer-shell # transparency for wlogout
        swayest-workstyle # dynamic workspace titles
        pulseaudio # for pactl

        # Terminal
        neovim 
        gcc
        cmake
        eza
        neofetch
        bottom
        powertop
        wget
        networkmanager
        networkmanagerapplet
        killall
        tree
        zoxide
        tree-sitter
        rclone

        # Windowed
        pavucontrol
        networkmanagerapplet
        firefox
        imv
        mpv
        zathura
        gimp
        pcmanfm

        # Fonts
        nerdfonts
        font-awesome
        jetbrains-mono
      ];

      # Link extra config files
      xdg.configFile."nvim/init.lua".source = ./dotfiles/neovim/init.lua;
      xdg.configFile."waybar/config".source = ./dotfiles/waybar/config;
      xdg.configFile."swaylock/config".source = ./dotfiles/swaylock/config;
      xdg.configFile."sworkstyle/config.toml".source = ./dotfiles/sworkstyle/config.toml;
      xdg.configFile."sway/config".source = ./dotfiles/sway/config;
      xdg.configFile."sway/wallpaper.png".source = ./dotfiles/sway/wallpaper.png;
      xdg.configFile."wlogout".source = ./dotfiles/wlogout;

      fonts.fontconfig.enable = true;
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
    gparted
  ];

  # Some programs need SUID wrappers, can be configured further or are started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}

# Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
