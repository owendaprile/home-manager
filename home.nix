{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "owen";
  home.homeDirectory = "/var/home/owen";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Allow unfree packages. (See https://github.com/nix-community/home-manager/issues/2942)
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Enable fish
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
    };
  };
  
  # Enable git
  programs.git = {
    enable = true;
    
    userName = "Owen D'Aprile";
    userEmail = "git@owen.sh";
    
    aliases = {
      lg = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
    };
    
    extraConfig = {
      # Enable commit signing with my 1Password key.
      commit.gpgsign = true;
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/opt/1Password/op-ssh-sign";
      user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";

      init.defaultBranch = "main";
      
      # Use git-credential-manager
      credential = {
        credentialStore = "secretservice";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };
  
  programs.vscode = {
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
  
  # Configure MangoHud (without installing?)
  programs.mangohud = {
    enable = true;
    settings = {
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_mhz = true;
      cpu_load_change = true;
      cpu_load_color = [ "FFFFFF" "FFFF00" "FF0000" ];
      
      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      vulkan_driver = true;
      gpu_load_change = true;
      gpu_load_color = [ "FFFFFF" "FFFF00" "FF0000" ];
      
      fps = true;
      
      frame_timing = 10;
      
      font_scale = 0.8;
      
      io_read = true;
      io_write = true;
      
      ram = true;
      swap = true;
      vram = true;
      
      engine_version = true;
      wine = true;
      
      no_display = true;
      
      toggle_hud = "Alt_L+z";
    };
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bat ffmpeg htop neovim restic yt-dlp
    plex-mpv-shim
    
    git-credential-manager
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };
  
  # Set files in XDG config directory.
  xdg.configFile = {
    "autostart/1password.desktop".text = ''
      [Desktop Entry]
      Name=1Password
      Type=Application
      Exec=/opt/1Password/1password --silent
    '';
  };
  
  # Set systemd session variables.
  systemd.user.sessionVariables = {
    # CLI
    EDITOR = "nvim";
    MANPAGER = "sh -c 'col -bx | bat -l man -p'";
    MANROFFOPT = "-c"
    BAT_PAGER = "less --chop-long-lines --ignore-case --LONG-PROMPT --quit-if-one-screen  --quit-on-intr --RAW-CONTROL-CHARS";
    SYSTEMD_LESS = "FIKMRS";
    
    # MangoHud
    MANGOHUD_LOG_LEVEL = "err";
    
    # XDG
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    
    # XDG Base Directory
    PYLINTHOME = "$XDG_CACHE_HOME/pylint";
    NUGET_PACKAGES = "$XDG_CACHE_HOME/nuget";
    CUDA_CACHE_PATH = "$XDG_CACHE_HOME/nv";
    GNUPGHOME = "$XDG_CONFIG_HOME/gnupg";
    IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
    NPM_CONFIG_USERCONFIG = "$XDG_CONFIG_HOME/npm/npmrc";
    PARALLEL_HOME = "$XDG_CONFIG_HOME/parallel";
    DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
    LESSHISTFILE = "$XDG_DATA_HOME/lesshst";
    CARGO_HOME = "$XDG_DATA_HOME/cargo";
    RUSTUP_HOME = "$XDG_DATA_HOME/rustup";
    GOPATH = "$XDG_DATA_HOME/go";
    GDBHISTFILE = "$XDG_DATA_HOME/gdb/history";
    MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker-machine";
    NODE_REPL_HISTORY = "$XDG_DATA_HOME/node_repl_history";
    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=$XDG_CONFIG_HOME/java";
    
    # Show home-manager apps in launcher.
    XDG_DATA_DIRS = "\$HOME/.nix-profile/share:\$XDG_DATA_DIRS";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
