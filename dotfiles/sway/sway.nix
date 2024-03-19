{pkgs,...}:

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
        gnome_schema=org.gnome.desktop.interface
        gsettings set $gnome_schema gtk-theme 'Dracula'
    '';
    };
in {
  home.packages = with pkgs; [
    # Sway
    dbus-sway-environment
    configure-gtk

    dbus # make dbus-update-activation-environment available in the path
    wayland # window system
    xdg-utils # for opening default programs when clicking links
    glib # gsettings
    dracula-theme # gtk theme
    gnome3.adwaita-icon-theme # default gnome cursors
    swaylock-effects # lock screen
    swayidle # idle monitor
    brightnessctl # brightness
    grim # screenshots
    slurp # screenshots
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    bemenu # menu
    swaynotificationcenter # notification center
    wdisplays # tool to configure displays
    wlogout # logout menu
    gtk-layer-shell # transparency for wlogout
    swayest-workstyle # dynamic workspace titles
    pulseaudio # for pactl
    kanshi # auto display config
  ];

  programs.waybar = { # Bar
    enable = true;
    style = ../waybar/style.css;
  };

  # Link extra config files
  xdg.configFile."waybar/config".source = ../waybar/config;
  xdg.configFile."swaylock/config".source = ../swaylock/config;
  xdg.configFile."sworkstyle/config.toml".source = ../sworkstyle/config.toml;
  xdg.configFile."sway/config".source = ./config;
  xdg.configFile."sway/wallpaper.png".source = ./wallpaper.png;
  xdg.configFile."wlogout".source = ../wlogout;
}
