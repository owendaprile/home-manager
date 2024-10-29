{ config, pkgs, ... }:

{
  xdg.configFile = {
    "environment.d/10-home-manager.conf".text = ''
      # CLI
      EDITOR = "hx"
      MANPAGER = "sh -c 'col -bx | bat -l man -p'"
      MANROFFOPT = "-c"
      BAT_PAGER = "less -FIKMFRS"
      BAT_THEME = "gruvbox-dark"
      SYSTEMD_LESS = "FIKMRS"

      # MangoHud
      MANGOHUD_LOG_LEVEL = "err"

      # Docker
      DOCKER_HOST = "unix://$XDG_RUNTIME_DIR/podman/podman.sock"

      # Restic
      RESTIC_REPOSITORY = "sftp:avery@chert.tailnet-aa28.ts.net:/var/mnt/gengar/restic/"

      # XDG
      XDG_CACHE_HOME = "$HOME/.cache"
      XDG_CONFIG_HOME = "$HOME/.config"
      XDG_DATA_HOME = "$HOME/.local/share"
      XDG_STATE_HOME  = "$HOME/.local/state"

      # XDG Base Directory
      HISTFILE = "$XDG_STATE_HOME/bash/history"
      CARGO_HOME = "$XDG_DATA_HOME/cargo"
      RUSTUP_HOME = "$XDG_DATA_HOME/rustup"
      GRADLE_USER_HOME = "$XDG_DATA_HOME/gradle"
      ANDROID_USER_HOME = "$XDG_DATA_HOME/android"
      KONAN_DATA_DIR = "$XDG_DATA_HOME/konan"
      NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc"
      NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history"

      # Show home-manager apps in launcher.
      #XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS"

      PATH = "/nix/var/nix/profiles/default/bin:$PATH"
      PATH = "$XDG_STATE_HOME/nix/profiles/profile/bin:$PATH"
      PATH = "$HOME/.local/bin:$PATH"
    '';

    "npm/npmrc".text = ''
      prefix = "''${XDG_DATA_HOME}/npm";
      cache = "''${XDG_CACHE_HOME}/npm";
      tmp = "''${XDG_RUNTIME_DIR}/npm";
      init-module = "''${XDG_CONFIG_HOME}/npm/config/npm-init.js";
    '';
  };
}
