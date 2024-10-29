{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ wl-clipboard ];

  programs.fish = {
    enable = true;

    functions = {
      clip = ''
        # Check session type to know what command to use
        if test $XDG_SESSION_TYPE = x11
          # Test for xclip
          if ! type -q xclip
          echo -e "Error: xclip must be installed to copy on an X11 session"
          end

          # Run xclip
          command xclip -selection c
        else if test $XDG_SESSION_TYPE = wayland
          # Test for wl-copy
          if ! type -q wl-copy
          echo -e "Error: wl-clipboard must be installed to copy on a Wayland session"
          end

          # Run wl-copy
          command wl-copy
        else
          # Unknown session
          printf "Error: unknown session type $XDG_SESSION_TYPE"
        end
      '';

      edit = "flatpak run --file-forwarding org.gnome.TextEditor @@ $argv @@";

      fish_greeting = ''
        systemctl --user list-units --quiet --state=failed
      '';

      rm = ''
        echo "rm is disabled. use `ts` to move items to trash, or `command rm` to use rm."
      '';
    };

    shellAliases = {
      adb = "HOME=\"$XDG_DATA_HOME/android\" adb";
      cat = "bat";
      tdn = "toolbox run --container fedora-toolbox-latest ~/.local/bin/tdn";
      ts = "gio trash";
    };

    plugins = [
      {
        name = "replay";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "replay.fish";
          rev = "1.2.1";
          sha256 = "bM6+oAd/HXaVgpJMut8bwqO54Le33hwO9qet9paK1kY=";
        };
      }
    ];
  };
}
