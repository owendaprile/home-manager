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
    bat fd helix nix-index ripgrep yt-dlp
  ];

  # Import configuration modules.
  imports = [ ./modules ];
}
