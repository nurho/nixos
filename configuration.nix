# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

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
  imports =
    [ # Include the results of the hardware scan.
      inputs.home-manager.nixosModules.home-manager
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

   networking.hostName = "nixos"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.
   networking.networkmanager.enable = true; # Easiest to use and most distros use by default.

  # Set your time zone.
   time.timeZone = "Europe/London";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
   i18n.defaultLocale = "en_GB.UTF-8";
   console = {
     font = "Lat2-Terminus16";
     keyMap = "uk";
  #   useXkbConfig = true; # use xkb.options in tty.
   };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;
  
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "willow";
      };
    };
  };

  nixpkgs.config.allowUnfree = true;

  # enable zsh and oh my zsh
  programs = {
     zsh = {
        enable = true;
        autosuggestions.enable = true;
        zsh-autoenv.enable = true;
        syntaxHighlighting.enable = true;
        ohMyZsh = {
           enable = true;
           theme = "agnoster";
           plugins = [
             "git"
             "history"
             "vi-mode"
             "rust"
           ];
        };
     };
  };
  users.defaultUserShell = pkgs.zsh;
  programs.waybar.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "gb";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = false;

  programs.light.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.willow = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ]; # Enable ‘sudo’ for the user.
  #   packages = with pkgs; [
  #   ];
  };

    # home-manager is used for user-level configuration, e.g. dotfiles
  home-manager = {
    extraSpecialArgs = { inherit inputs outputs; };
    users.willow = {
      home = {
        username = "willow";
        homeDirectory = "/home/willow";
        stateVersion = "23.05"; # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      };
      
      imports = [
      ];

      # installed programs
      home.packages = with pkgs; [
        tree
        zoxide
      ];
    };
  };

  # List packages installed in system profile. To search, run: $ nix search wget
  environment.systemPackages = with pkgs; [
    # Sway
    dbus # make dbus-update-activation-environment available in the path
    dbus-sway-environment
    configure-gtk
    wayland
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
    swaylock-effects # lock screen
    swayidle # idle monitor
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
    wezterm
    neovim 
    helix
    git
    gcc
    cmake
    eza
    neofetch
    htop
    btop
    wget
    networkmanager
    networkmanagerapplet
    killall

    # windowed
    pavucontrol
    networkmanagerapplet
    firefox
    imv
    mpv
    zathura
    gimp
  ];

  fonts.packages = with pkgs; [
    nerdfonts
    font-awesome_5
    jetbrains-mono
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
