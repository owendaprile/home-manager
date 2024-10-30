{ pkgs, ... }:

{
  # Enable and configure Git.
  programs.git = {
    enable = true;
    lfs.enable = true;

    userName = "Owen D'Aprile";
    userEmail = "git@owen.sh";

    extraConfig = {
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

  # Add Git-related packages.
  home.packages = with pkgs; [ gh git-credential-manager ];
}
