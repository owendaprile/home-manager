{ config, pkgs, ... }:

{
  home.username = "owen";
  home.homeDirectory = "/var/home/owen";

  # Allow unfree packages.
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Install command line tools only. GUI apps won't work without nixGL.
  home.packages = with pkgs; [
    bat fd ffmpeg gcc git-credential-manager mkosi restic ripgrep rr rustup wl-clipboard yt-dlp
  ];

  programs.fish = {
    enable = true;

    functions = {
      clip = ''
        # Check session type to know what command to use
        if test $XDG_SESSION_TYPE = x11
          # Test for xclip
          if ! type -q xclip
          echo -e "Error: xclip must be installed to copy on an X11 session"
          end

          # Run xclip
          command xclip -selection c
        else if test $XDG_SESSION_TYPE = wayland
          # Test for wl-copy
          if ! type -q wl-copy
          echo -e "Error: wl-clipboard must be installed to copy on a Wayland session"
          end

          # Run wl-copy
          command wl-copy
        else
          # Unknown session
          printf "Error: unknown session type $XDG_SESSION_TYPE"
        end
      '';

      edit = "flatpak run --file-forwarding org.gnome.TextEditor @@ $argv @@";

      fish_greeting = "";
    };

    shellAliases = {
      adb = "HOME=\"$XDG_DATA_HOME/android\" adb";
    };

    plugins = [
      {
        name = "replay";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "replay.fish";
          rev = "1.2.1";
          sha256 = "bM6+oAd/HXaVgpJMut8bwqO54Le33hwO9qet9paK1kY=";
        };
      }
    ];
  };

  programs.ssh = {
    enable = true;
    matchBlocks."*".extraOptions.IdentityAgent = "~/.1password/agent.sock";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Owen D'Aprile";
    userEmail = "git@owen.sh";

    extraConfig = {
      # Enable commit signing with 1Password.
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/opt/1Password/op-ssh-sign";
      "gpg \"ssh\"".allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      commit.gpgsign = true;

      commit.verbose = true;
      init.defaultBranch = "main";
      pull.ff = "only";
      merge.conflictStyle = "zdiff3";
      rebase.autoSquash = true;
      push.default = "current";
      diff.algorithm = "histogram";
      diff.colorMoved = "default";
      transfer.fsckObjects = true;
      fetch.fsckObjects = true;
      receive.fsckObjects = true;
      branch.sort = "-committerdate";
      tag.sort = "taggerdate";
      core.autocrlf = "input";

      # Enable git-credential-manager.
      credential = {
        credentialStore = "secretservice";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };

  programs.tmux = {
    enable = true;
  };

  programs.htop = {
    enable = true;

    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
      shadow_other_users = true;
      highlight_base_name = true;
      highlight_deleted_exe = true;
      shadow_distribution_path_prefix = true;
      highlight_changes = true;
      highlight_changes_delay_secs = 1;
      screen_tabs = false;
      enable_mouse = true;
      delay = 10;
      tree_view = true;

      fields = with config.lib.htop.fields; [
        PID USER PRIORITY STATE STARTTIME M_RESIDENT PERCENT_CPU TIME COMM
      ];

      header_layout = "two_33_67";
    } // (with config.lib.htop; leftMeters [
      (text "Hostname")
      (text "Uptime")
      (text "LoadAverage")
      (text "Tasks")
      (text "DiskIO")
      (text "NetworkIO")
      (text "SELinux")
      (text "Systemd")
    ]) // (with config.lib.htop; rightMeters [
      (bar "AllCPUs4")
      (bar "Memory")
      (bar "Zram")
    ]);
  };

  programs.mangohud = {
    enable = true;
    enableSessionWide = true;

    settings = {
      # Show CPU info.
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = false;
      cpu_mhz = true;
      cpu_load_change = true;
      cpu_load_color = "FFFFFF,FFFF00,FF0000";

      # Show GPU info. (Doesn't work with NVK)
      gpu_stats = false;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_load_change = true;
      gpu_load_color = "FFFFFF,FFFF00,FF0000";
      vram = false;

      # Other.
      fps = true;
      frame_timing = 10;
      # font_scale = 0.95;
      font_size = 20;
      position = "top-left";
      io_read = true;
      io_write = true;
      ram = true;
      swap = true;
      engine_version = true;
      vulkan_driver = true;
      wine = true;
      output_folder = "${config.home.homeDirectory}/MangoHud";
      round_corners = 4;

      # Hide by default.
      no_display = true;
      toggle_hud = "Alt_L+z";
    };
  };

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
        PATH = "$XDG_STATE_HOME/nix/profile/bin:$PATH"
        PATH = "$HOME/.local/bin:$PATH"
    '';

    "git/allowed_signers".text = "git@owen.sh ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";

    "npm/npmrc".text = ''
      prefix = "''${XDG_DATA_HOME}/npm";
      cache = "''${XDG_CACHE_HOME}/npm";
      tmp = "''${XDG_RUNTIME_DIR}/npm";
      init-module = "''${XDG_CONFIG_HOME}/npm/config/npm-init.js";
    '';

    "tmux/tmux.conf".text = ''
      ########################
      ### USABILITY TWEAKS ###
      ########################

      # Make sure tmux uses 24 bit color
      set -g default-terminal "xterm-256color"
      set -ga terminal-overrides ",*256col*:Tc"

      # Change the prefix key to ctrl+a
      unbind C-b
      set-option -g prefix C-a
      bind-key C-a send-prefix

      # Change the split commands to | and -
      unbind '"'
      unbind %
      bind | split-window -h
      bind - split-window -v

      # Reload config file
      bind r source-file ~/.tmux.conf

      # Switch panes with meta+arrow keys
      bind -n M-Left select-pane -L
      bind -n M-Right select-pane -R
      bind -n M-Up select-pane -U
      bind -n M-Down select-pane -D

      ## Enable mouse mode
      set -g mouse on

      # Start windows and panes at 1
      set -g base-index 1
      setw -g pane-base-index 1

      ######################
      ### DESIGN CHANGES ###
      ######################

      #set -g visual-activity off
      #set -g visual-bell off
      #set -g visual-silence off
      #setw -g monitor-activity off
      #set - bell-action none

      #setw -g clock-mode-colour colour5
      #setw -g mode-style 'fg=colour1 bg=colour18 bold'

      #set -g pane-border-style 'fg=colour19 bg=colour0'
      #set -g pane-active-border-style 'bg=colour0 fg=colour9'

      #set -g status-position top
      #set -g status-justify left
      #set -g status-style 'bg=colour235 fg=colour223 dim'
      #set -g status-left \'\'
      #set -g status-right '#[fg=colour233, bg=colour8] %H:%M:%S '
      #set -g status-right-length 50
      #set -g status-left-length 20

      #setw -g window-status-current-style 'bg=colour239 fg=colour214 bold'
      #setw -g window-status-current-format ' #I #[fg=colour255]#W#[fg=colour249]#F '

      #setw -g window-status-style 'bg=colour237'
      #setw -g window-status-format ' #I#[fg=colour237]:#[fg=colour250]#W#[fg=colour244]#F '

      #setw -g window-status-bell-style 'fg=colour255 bg=colour1 bold'

      #set -g message-style 'fg=colour232 bg=colour16 bold'


      ### ME!
      set -g status-position top
      set -g status-justify left

      ### GRUVBOX?
      ## COLORSCHEME: gruvbox dark
      set-option -g status "on"

      # default statusbar color
      set-option -g status-style bg=colour237,fg=colour223 # bg=bg1, fg=fg1

      # default window title colors
      set-window-option -g window-status-style bg=colour214,fg=colour237 # bg=yellow, fg=bg1

      # default window with an activity alert
      set-window-option -g window-status-activity-style bg=colour237,fg=colour248 # bg=bg1, fg=fg3

      # active window title colors
      set-window-option -g window-status-current-style bg=red,fg=colour237 # fg=bg1

      # pane border
      set-option -g pane-active-border-style fg=colour250 #fg2
      set-option -g pane-border-style fg=colour237 #bg1

      # message infos
      set-option -g message-style bg=colour239,fg=colour223 # bg=bg2, fg=fg1

      # writing commands inactive
      set-option -g message-command-style bg=colour239,fg=colour223 # bg=fg3, fg=bg1

      # pane number display
      set-option -g display-panes-active-colour colour250 #fg2
      set-option -g display-panes-colour colour237 #bg1

      # clock
      set-window-option -g clock-mode-colour colour109 #blue

      # bell
      set-window-option -g window-status-bell-style bg=colour167,fg=colour235 # bg=red, fg=bg

      ## Theme settings mixed with colors (unfortunately, but there is no cleaner way)
      set-option -g status-justify "left"
      set-option -g status-left-style none
      set-option -g status-left-length "80"
      set-option -g status-right-style none
      set-option -g status-right-length "80"
      set-window-option -g window-status-separator ""

      set-option -g status-left "#[fg=colour248, bg=colour241] #S #[fg=colour241, bg=colour237, nobold, noitalics, nounderscore]"
      set-option -g status-right "#[fg=colour239, bg=colour237, nobold, nounderscore, noitalics]#[fg=colour246,bg=colour239] %H:%M #[fg=colour248, bg=colour239, nobold, noitalics, nounderscore]#[fg=colour237, bg=colour248] #h "

      set-window-option -g window-status-current-format "#[fg=colour237, bg=colour214, nobold, noitalics, nounderscore]#[fg=colour239, bg=colour214] #I#[fg=colour239, bg=colour214, bold] #W #[fg=colour214, bg=colour237, nobold, noitalics, nounderscore]"
      set-window-option -g window-status-format "#[fg=colour237,bg=colour239,noitalics]#[fg=colour223,bg=colour239] #I#[fg=colour223, bg=colour239] #W #[fg=colour239, bg=colour237, noitalics]"
    '';
  };

  home.file = {
    ".local/bin/bwrap-preset-renpy" = {
      executable = true;
      text = ''
      #!/usr/bin/env sh

      # bwrap-preset-renpy
      #
      # Run an executable in a Bubblewrap sandbox set up for Ren'Py games. The saves
      # directory will be in '$XDG_CONFIG_DIR/renpy' or '$HOME/.config/renpy' instead
      # of the normal '$HOME/.renpy'.

      set -eu

      # Set script title for error messages.
      SCRIPT_TITLE="Run in Bubblewrap (Ren'Py)"

      # Notify the user of an error and exit.
      notify_and_exit () {
          # Make sure enough arguments were given.
          if [ "$#" -ne 2 ]; then
              printf "Error: notify_and_exit() called with '%i' arguments\n" "$#"
              exit 127
          fi

          # Name the arguments.
          error_msg="$1"
          exit_code="$2"

          # Either print to stdout or send a notification.
          if [ "$TERM" = "dumb" ]; then
              notify-send --urgency=normal --icon=error "$SCRIPT_TITLE" "$error_msg"
          else
              printf "%s: %s\n" "$SCRIPT_TITLE" "$error_msg"
          fi

          # Exit with the error code.
          exit "$exit_code"
      }

      # Only one command can be run.
      [ "$#" -ne 1 ] && notify_and_exit "Only one command can be run with this script" 1


      # Make sure Bubblewrap is installed.
      if ! command -v bwrap > /dev/null 2>&1; then
          notify_and_exit "Could not find executable \`bwrap\`" 1
      fi

      # Set the Ren'Py saves directory.
      if [ ! -z "$\{XDG_CONFIG_HOME+x\}" ]; then
          RENPY_SAVE_DIR="$XDG_CONFIG_HOME/renpy"
      else
          RENPY_SAVE_DIR="$HOME/.config/renpy"
      fi

      # Create the Ren'Py saves directory if it doesn't exist.
      [ ! -d "$RENPY_SAVE_DIR" ] && mkdir -p "$RENPY_SAVE_DIR"

      # Get the full path of the file.
      executable=$(realpath "$1")

      # Get the directory the file is contained in so it can be mounted int the
      # sandbox.
      executable_dir=$(dirname "$executable")

      # Make sure the file is executable.
      [ ! -x "$executable" ] && notify_and_exit "File \`$executable\` is not executable" 1

      # Run the specified command in Bubblewrap. Unshare all namespaces, and bind the
      # working directory and Ren'Py saves directory.
      exec bwrap \
          --unshare-all \
          --die-with-parent \
          --new-session \
          --ro-bind "/" "/" \
          --dev "/dev" \
          --dev-bind "/dev/dri" "/dev/dri" \
          --proc "/proc" \
          --tmpfs "$HOME" \
          --bind "$executable_dir" "$executable_dir" \
          --bind "$RENPY_SAVE_DIR" "$HOME/.renpy" \
          --setenv "MESA_LOADER_DRIVER_OVERRIDE" "zink" \
          "$executable"
      '';
    };

    ".local/share/nautilus/scripts/Run in Bubblewrap (Ren'Py)" = {
      source = config.home.file.".local/bin/bwrap-preset-renpy".source;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/background" = {
      picture-uri = "file:///usr/share/backgrounds/gnome/adwaita-l.jxl";
      picture-uri-dark = "file:///usr/share/backgrounds/gnome/adwaita-d.jxl";
    };
    "org/gnome/desktop/datetime" = { automatic-timezone = true; };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      clock-show-weekday = true;
      monospace-font-name = "IntelOne Mono 10";
      show-battery-percentage = true;
    };
    "org/gnome/desktop/media-handling" = { automount = false; };
    "org/gnome/desktop/peripherals/touchpad" = { tap-to-click = true; };
    "org/gnome/desktop/wm/preferences" = { action-middle-click-titlebar = "lower"; };
    "org/gnome/nautilus/preferences" = {
      show-create-link = true;
      show-delete-permanently = true;
    };
    "org/gnome/shell/app-switcher" = { current-workspace-only = true; };
    "org/gnome/system/location" = { enabled = true; };
  };

  systemd.user.services = {
    "1password" = {
      Unit = {
        Description = "1Password password manager";
        After = "graphical-session.target";
        PartOf = "graphical-session.target";
      };
      Service = {
        Type = "exec";
        ExitType = "cgroup";
        ExecStart = "/opt/1Password/1password --silent";
        Restart = "always";
        Slice = "app.slice";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };
  };

  programs.home-manager.enable = true;
  news.display = "silent";
  home.stateVersion = "24.05";
}
