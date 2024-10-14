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

  programs.git = {
    extraConfig = {
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/opt/1Password/op-ssh-sign";
      "gpg \"ssh\"".allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      commit.gpgsign = true;
    };
  };

  xdg.configFile."git/allowed_signers".text =
    "git@owen.sh ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";

  programs.ssh.matchBlocks."*".extraOptions.IdentityAgent = "~/.1password/agent.sock";
}
