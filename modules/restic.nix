{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ restic ];

  xdg.configFile = {
    "restic/backup.conf".text = ''
      RESTIC_REPOSITORY="s3:s3.us-east-005.backblazeb2.com/restic-e59740da"
      RESTIC_PASSWORD="HjFmai_j.its3uYs8qFW"

      AWS_ACCESS_KEY_ID=00549cbef09a1330000000002
      AWS_SECRET_ACCESS_KEY=K005LM7ffOfjHy+bu7Nr/XshKYJaqvc

      BACKUP_PATHS=/var/home/owen
      BACKUP_TAGS=Automatic

      UPLOAD_LIMIT=5000

      RETENTION_DAYS=7
      RETENTION_WEEKS=4
      RETENTION_MONTHS=12
      RETENTION_YEARS=unlimited
    '';

    "restic/excludes.conf".text = ''
      $HOME/.1password/
      $HOME/.android/
      $HOME/.BitwigStudio/
      $HOME/.cache/
      $HOME/.gradle/
      $HOME/.java/
      $HOME/.local/share/
      $HOME/.local/state/
      $HOME/.jdks/
      $HOME/.pki/
      $HOME/.skiko/
      $HOME/.vscode/

      $HOME/Downloads/
      $HOME/Dropbox/
      $HOME/Google Drive/
      $HOME/Music/
      $HOME/Videos/

      $HOME/.var/app/**/cache/
      $HOME/.var/app/**/.cache/
      $HOME/.var/app/**/data/
      $HOME/.var/app/**/.local/share/

      **/mkosi.cache/
      **/mkosi.output/
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
        ExecStopPost = "restic unlock --remove-all";
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

  programs.fish.functions = {
    restic-chert = {
      wraps = "restic";
      body = ''
        set OP_ITEM_ID "b2sf5yjq54bmckhib5pfnln2ay"
        set -x RESTIC_REPOSITORY "op://Private/$OP_ITEM_ID/restic repository"
        set -x RESTIC_PASSWORD "op://Private/$OP_ITEM_ID/restic password"
        set -x AWS_ACCESS_KEY_ID "op://Private/$OP_ITEM_ID/access key id"
        set -x AWS_SECRET_ACCESS_KEY "op://Private/$OP_ITEM_ID/secret access key"

        command op run -- restic $argv
      '';
    };

    restic-pulsar = {
      wraps = "restic";
      body = ''
        set OP_ITEM_ID "fikkpqldm7vhrhbenjgbnlqyb4"
        set -x RESTIC_REPOSITORY "op://Private/$OP_ITEM_ID/restic repository"
        set -x RESTIC_PASSWORD "op://Private/$OP_ITEM_ID/restic password"
        set -x AWS_ACCESS_KEY_ID "op://Private/$OP_ITEM_ID/access key id"
        set -x AWS_SECRET_ACCESS_KEY "op://Private/$OP_ITEM_ID/secret access key"

        command op run -- restic $argv
      '';
    };
  };
}
