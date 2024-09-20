{ config, pkgs, ... }:

{
  home.packages = [ pkgs.restic ];

  xdg.configFile = {
    "restic/backup.conf".text = ''
      RESTIC_REPOSITORY="sftp:avery@chert.tailnet-aa28.ts.net:/var/mnt/gengar/restic"
      RESTIC_PASSWORD="zW2jUAsqxkvJmRowLuip"

      BACKUP_PATHS=/var/home/owen
      BACKUP_TAGS=Automatic

      UPLOAD_LIMIT=4000

      RETENTION_DAYS=7
      RETENTION_WEEKS=4
      RETENTION_MONTHS=12
      RETENTION_YEARS=unlimited
    '';

    "restic/excludes.conf".text = ''
      $HOME/.1password
      $HOME/.android
      $HOME/.BitwigStudio
      $HOME/.cache
      $HOME/.gradle
      $HOME/.java
      $HOME/.local/share
      $HOME/.local/state
      $HOME/.jdks
      $HOME/.pki
      $HOME/.skiko

      $HOME/Downloads
      $HOME/Dropbox
      $HOME/Google Drive
      $HOME/Music
      $HOME/Videos

      $HOME/.var/app/**/cache
      $HOME/.var/app/**/.cache
      $HOME/.var/app/**/data
      $HOME/.var/app/**/.local/share
    '';
  };

  systemd.user = {
    services.restic-backup = {
      Unit = {
        Description = "Backup home directory";
        After = "network-online.target";
        Wants = "network-online.target";
      };
      Service = {
        Type = "oneshot";
        Environment = "XDG_CACHE_HOME=%T";
        EnvironmentFile = "%h/.config/restic/backup.conf";
        ExecStart = "restic backup --verbose --limit-upload \"$UPLOAD_LIMIT\" --exclude-file %h/.config/restic/excludes.conf --exclude-caches --tag \"$BACKUP_TAGS\" $BACKUP_PATHS";
        ExecStartPost = "restic forget --verbose --tag \"$BACKUP_TAGS\" --keep-daily \"$RETENTION_DAYS\" --keep-weekly \"$RETENTION_WEEKS\" --keep-monthly \"$RETENTION_MONTHS\" --keep-yearly \"$RETENTION_YEARS\"";
        TimeoutStopSec = "2m";
        SendSIGKILL = false;
        SuccessExitStatus = 3;
      };
    };

    timers.restic-backup = {
      Unit = {
        Description = "Schedule a backup of the home directory";
      };
      Timer = {
        OnCalendar = "daily";
        Persistent = true;
        AccuracySec = "30m";
      };
      Install = {
        WantedBy = [ "timers.target" ];
      };
    };
  };
}
