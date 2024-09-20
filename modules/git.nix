{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Owen D'Aprile";
    userEmail = "git@owen.sh";

    extraConfig = {
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

      credential = {
        credentialStore = "secretservice";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };

  xdg.configFile."git/allowed_signers".text =
    "git@owen.sh ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEFU4lMOhpVNMEmsMxpIi06oEnFC0WNn5UkTYs5cMXDC";
}
