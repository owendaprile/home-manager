{ ... }:

{
  # Add modules here.
  imports = [
    ./1password.nix
    ./environment.nix
    ./fish.nix
    ./git.nix
    ./gnome.nix
    ./htop.nix
    ./mangohud.nix
    ./restic.nix
    ./scripts.nix
    ./ssh.nix
    ./tmux.nix
    ./zed.nix
  ];
}
