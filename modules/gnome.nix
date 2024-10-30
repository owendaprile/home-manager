{ ... }:

{
  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file:///usr/share/backgrounds/gnome/adwaita-l.jxl";
      picture-uri-dark = "file:///usr/share/backgrounds/gnome/adwaita-d.jxl";
    };
    "org/gnome/desktop/datetime" = { automatic-timezone = true; };
    "org/gnome/desktop/interface" = {
      accent-color = "purple";
      clock-format = "24h";
      clock-show-weekday = true;
      color-scheme = "prefer-dark";
      monospace-font-name = "IntelOne Mono 10";
      show-battery-percentage = true;
    };
    "org/gnome/desktop/media-handling" = { automount = false; };
    "org/gnome/desktop/notifications" = { show-in-lock-screen = false; };
    "org/gnome/desktop/peripherals/touchpad" = { tap-to-click = true; };
    "org/gnome/desktop/session" = { idle-delay = 300; };
    "org/gnome/desktop/wm/preferences" = { action-middle-click-titlebar = "lower"; };
    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
      show-delete-permanently = true;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      power-button-action = "interactive";
      power-saver-profile-on-low-battery = true;
    };
    "org/gnome/shell/app-switcher" = { current-workspace-only = true; };
    "org/gnome/system/location" = { enabled = true; };
  };
}
