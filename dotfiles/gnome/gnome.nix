{
  "org/gnome/desktop/sound" = { allow-volume-above-100-percent = true; };

  "org/gnome/desktop/interface" = {
    show-battery-percentage = true;
    clock-show-weekday = true;
    color-scheme = "prefer-dark";
  };

  "org/gnome/shell/keybindings" = {
    toggle-application-view = [];
    toggle-message-tray = [];
    toggle-overview = ["<Super>g"];
    toggle-quick-settings = [];
    switch-to-application-1 = [];
    switch-to-application-2 = [];
    switch-to-application-3 = [];
    switch-to-application-4 = [];
    switch-to-application-5 = [];
    switch-to-application-6 = [];
    switch-to-application-7 = [];
    switch-to-application-8 = [];
    switch-to-application-9 = [];
  };

  "org/gnome/mutter" = { overlay-key = []; };

  "org/gnome/shell" = {
    favorite-apps = [];
#    enabled-extensions = ["launch-new-instance@gnome-shell-extensions.gcampax.github.com"];
    enabled-extensions = [
        "workspaces-by-open-apps@gnome-shell-extensions.Favo02.github.com"
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com"
    ];
  };

  "org/gnome/shell/window-switcher" = { current-workspace-only = true; };

  "org/gnome/desktop/wm/keybindings" = {
    switch-windows = ["<Alt>Tab"];
    close = ["<Super>Backspace"];
    switch-to-workspace-1 = ["<Super>1"];
    move-to-workspace-1 = ["<Super><Shift>1"];
    switch-to-workspace-2 = ["<Super>2"];
    move-to-workspace-2 = ["<Super><Shift>2"];
    switch-to-workspace-3 = ["<Super>3"];
    move-to-workspace-3 = ["<Super><Shift>3"];
    switch-to-workspace-4 = ["<Super>4"];
    move-to-workspace-4 = ["<Super><Shift>4"];
    switch-to-workspace-5 = ["<Super>5"];
    move-to-workspace-5 = ["<Super><Shift>5"];
    switch-to-workspace-6 = ["<Super>6"];
    move-to-workspace-6 = ["<Super><Shift>6"];
    switch-to-workspace-7 = ["<Super>7"];
    move-to-workspace-7 = ["<Super><Shift>7"];
    switch-to-workspace-8 = ["<Super>8"];
    move-to-workspace-8 = ["<Super><Shift>8"];
    switch-to-workspace-9 = ["<Super>9"];
    move-to-workspace-9 = ["<Super><Shift>9"];
    switch-to-workspace-10 = ["<Super>0"];
    move-to-workspace-10 = ["<Super><Shift>0"];
  };

  "org/gnome/desktop/wm/preferences" = { num-workspaces = 10; };

  "org/gnome/desktop/input-sources" = { xkb-options = ["caps:escape_shifted_capslock"]; };

  "org/gnome/settings-daemon/plugins/media-keys" = {
    custom-keybindings = [ "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/" ];
  };
  "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
    binding = "<Super>t";
    command = "wezterm start --always-new-process";
    name = "open-terminal";
  };
}
