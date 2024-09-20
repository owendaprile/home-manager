{ config, pkgs, ... }:

{
  # Configure Home Manager.
  home.username = "owen";
  home.homeDirectory = "/var/home/owen";
  programs.home-manager.enable = true;
  news.display = "silent";
  home.stateVersion = "24.05";

  # Allow unfree packages.
  nixpkgs.config.allowUnfreePredicate = (pkg: true);

  # Install command line programs.
  home.packages = with pkgs; [
    bat fd ffmpeg gcc git-credential-manager mkosi restic ripgrep rr rustup wl-clipboard yt-dlp
  ];

  # Import extra configuration modules.
  imports = [
    ./modules/autostart.nix
    ./modules/environment.nix
    ./modules/fish.nix
    ./modules/git.nix
    ./modules/gnome.nix
    ./modules/htop.nix
    ./modules/mangohud.nix
    ./modules/restic.nix
    ./modules/scripts.nix
    ./modules/ssh.nix
    ./modules/tmux.nix
  ];
}
