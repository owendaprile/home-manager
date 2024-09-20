{ config, pkgs, ... }:

{
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
}
