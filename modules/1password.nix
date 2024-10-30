{ config, ... }:

{
  # Autostart 1Password on login, restart it when it quits due to rpm-ostree
  # staging an update.
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

  # Configure Git to use the 1Password SSH key.
  programs.git = {
    extraConfig = {
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";
      gpg.format = "ssh";
      "gpg \"ssh\"".program = "/opt/1Password/op-ssh-sign";
      "gpg \"ssh\"".allowedSignersFile = "${config.home.homeDirectory}/.config/git/allowed_signers";
      commit.gpgsign = true;
    };
  };

  # Allow Git to verify commits signed by the 1Password SSH key.
  xdg.configFile."git/allowed_signers".text =
    "git@owen.sh ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";

  # Configure SSH to use 1Password for key authentication.
  programs.ssh.matchBlocks."*".extraOptions.IdentityAgent = "~/.1password/agent.sock";

  # Add shortcut for 1Password quick access.
  dconf.settings = {
    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings" = {
      binding = "<Super>c";
      command = "1password --quick-access";
      name = "1Password Quick Access (home-manager)";
    };
  };
}
