{ pkgs, ... }:

{
  home.file = {
    ".var/app/io.mpv.Mpv/config/mpv/mpv.conf".text = ''
      vo=dmabuf-wayland
      hwdec=auto-safe
      script-opts-append=autocrop-auto=no
    '';

    ".var/app/io.mpv.Mpv/config/mpv/scripts/autocrop.lua".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/mpv-player/mpv/refs/tags/v0.39.0/TOOLS/lua/autocrop.lua";
      hash = "sha256-QMxEtp/xqP6r1hMq3gBU5ZX6nqXgfxddLdmbIlQ/toM=";
    };
  };

  services.plex-mpv-shim = {
    enable = true;
    settings = {
      mpv_ext = true;
      mpv_ext_path = "/var/lib/flatpak/exports/bin/io.mpv.Mpv";
      fullscreen = false;
    };
  };
}
