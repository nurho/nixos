{ config, lib, pkgs, inputs, outputs, ... }:

  let
    dbus-sway-environment = pkgs.writeTextFile {
      name = "dbus-sway-environment";
      destination = "/bin/dbus-sway-environment";
      executable = true;
      text = ''
        dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=sway
        systemctl --user stop pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
        systemctl --user start pipewire pipewire-media-session xdg-desktop-portal xdg-desktop-portal-wlr
      '';
    };

    configure-gtk = pkgs.writeTextFile {
      name = "configure-gtk";
      destination = "/bin/configure-gtk";
      executable = true;
      text = let
      	schema = pkgs.gsettings-desktop-schemas;
        datadir = "${schema}/share/gsettings-schemas/${schema.name}";
      in ''
6        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
      '';
      };
  in
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


  # Login
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "willow";
      };
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
    extraGroups = [ "wheel" "video" "networkmanager" ];
  };

  # Home Manager (user-level configuration)
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users.willow = {
      home = {
        username = "willow";
        homeDirectory = "/home/willow";
        stateVersion = "23.11"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      };
      
      imports = [
      ];

      fonts.fontconfig.enable = true;

      # Programs requiring config
      programs = {

        # Shell
        nushell = {
          enable = true;
          configFile.text = builtins.readFile ./dotfiles/nu/config.nu;
          envFile.text = builtins.readFile ./dotfiles/nu/env.nu;
        };
        carapace = {
          enable = true;
          enableNushellIntegration = true;
        };

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
        programs.wezterm = {
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
        dbus-sway-environment
        configure-gtk
        wayland # window system
        xdg-utils # for opening default programs when clicking links
        glib # gsettings
        dracula-theme # gtk theme
        gnome3.adwaita-icon-theme # default gnome cursors
        waybar # bar
        swaylock-effects # lock screen
        swayidle # idle monitor
        light # brightness
        grim # screenshots
        slurp # screenshots
        wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
        bemenu # wayland clone of dmenu
        mako # notifications
        wdisplays # tool to configure displays
        wlogout # logout menu
        gtk-layer-shell # transparency for wlogout
        swayest-workstyle # dynamic workspace titles

        # Terminal
        neovim 
        helix
        git
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

        # Windowed
        pavucontrol
        networkmanagerapplet
        firefox
        imv
        mpv
        zathura
        gimp

        # Fonts
        nerdfonts
        font-awesome_5
        jetbrains-mono
      ];
    };
  };

  # System packages
  environment.systemPackages = with pkgs; [
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
