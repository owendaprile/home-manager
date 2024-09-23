{ config, pkgs, ... }:

{
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

    shellAliases = {
      adb = "HOME=\"$XDG_DATA_HOME/android\" adb";
      cat = "bat";
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
