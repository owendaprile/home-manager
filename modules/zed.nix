{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ nixd ];

  xdg.configFile."zed/settings.json".text = ''
  {
    "theme": "Ayu Dark",
    "buffer_font_size": 14,
    "buffer_font_family": "Intel One Mono",
    "format_on_save": "off",
    "wrap_guides": [100, 120],
    "autosave": {
      "after_delay": {
        "milliseconds": 1000
      }
    },
    "languages": {
      "Nix": {
        "tab_size": 2
      }
    },
    "chat_panel": {
      "button": false
    },
    "assistant": {
      "default_model": {
        "provider": "zed.dev",
        "model": "claude-3-5-sonnet-20240620"
      },
      "version": "2"
    },
    "features": {
      "inline_completion_provider": "none"
    }
  }
  '';

  xdg.configFile."zed/keymap.json".text = ''
  [
    {
      "context": "Editor",
      "bindings": {
        "ctrl-d": "editor::DeleteLine"
      }
    }
  ]
  '';
}
