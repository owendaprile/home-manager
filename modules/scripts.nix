{ config, ... }:

{
  home.file = {
    ".local/bin/bwrap-preset-renpy" = {
      executable = true;
      text = ''
        #!/usr/bin/env sh

        # bwrap-preset-renpy
        #
        # Run an executable in a Bubblewrap sandbox set up for Ren'Py games. The saves
        # directory will be in '$XDG_CONFIG_DIR/renpy' or '$HOME/.config/renpy' instead
        # of the normal '$HOME/.renpy'.

        set -eu

        # Set script title for error messages.
        SCRIPT_TITLE="Run in Bubblewrap (Ren'Py)"

        # Notify the user of an error and exit.
        notify_and_exit () {
            # Make sure enough arguments were given.
            if [ "$#" -ne 2 ]; then
                printf "Error: notify_and_exit() called with '%i' arguments\n" "$#"
                exit 127
            fi

            # Name the arguments.
            error_msg="$1"
            exit_code="$2"

            # Either print to stdout or send a notification.
            if [ "$TERM" = "dumb" ]; then
                notify-send --urgency=normal --icon=error "$SCRIPT_TITLE" "$error_msg"
            else
                printf "%s: %s\n" "$SCRIPT_TITLE" "$error_msg"
            fi

            # Exit with the error code.
            exit "$exit_code"
        }

        # Only one command can be run.
        [ "$#" -ne 1 ] && notify_and_exit "Only one command can be run with this script" 1


        # Make sure Bubblewrap is installed.
        if ! command -v bwrap > /dev/null 2>&1; then
            notify_and_exit "Could not find executable \`bwrap\`" 1
        fi

        # Set the Ren'Py saves directory.
        if [ ! -z "$\{XDG_CONFIG_HOME+x\}" ]; then
            RENPY_SAVE_DIR="$XDG_CONFIG_HOME/renpy"
        else
            RENPY_SAVE_DIR="$HOME/.config/renpy"
        fi

        # Create the Ren'Py saves directory if it doesn't exist.
        [ ! -d "$RENPY_SAVE_DIR" ] && mkdir -p "$RENPY_SAVE_DIR"

        # Get the full path of the file.
        executable=$(realpath "$1")

        # Get the directory the file is contained in so it can be mounted int the
        # sandbox.
        executable_dir=$(dirname "$executable")

        # Make sure the file is executable.
        [ ! -x "$executable" ] && notify_and_exit "File \`$executable\` is not executable" 1

        # Run the specified command in Bubblewrap. Unshare all namespaces, and bind the
        # working directory and Ren'Py saves directory.
        exec bwrap \
            --unshare-all \
            --die-with-parent \
            --new-session \
            --ro-bind "/" "/" \
            --dev "/dev" \
            --dev-bind "/dev/dri" "/dev/dri" \
            --proc "/proc" \
            --tmpfs "$HOME" \
            --bind "$executable_dir" "$executable_dir" \
            --bind "$RENPY_SAVE_DIR" "$HOME/.renpy" \
            --setenv "MESA_LOADER_DRIVER_OVERRIDE" "zink" \
            "$executable"
      '';
    };

    ".local/share/nautilus/scripts/Run in Bubblewrap (Ren'Py)".source =
      config.home.file.".local/bin/bwrap-preset-renpy".source;
  };
}
