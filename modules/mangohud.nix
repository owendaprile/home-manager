{ config, ... }:

{
  # Enable and configure MangoHud.
  programs.mangohud = {
    enable = true;

    settings = {
      cpu_stats = true;
      cpu_temp = true;
      cpu_power = true;
      cpu_mhz = true;
      cpu_load_change = true;
      cpu_load_color = "FFFFFF,FFFF00,FF0000";

      gpu_stats = true;
      gpu_temp = true;
      gpu_core_clock = true;
      gpu_mem_clock = true;
      gpu_power = true;
      gpu_load_change = true;
      gpu_load_color = "FFFFFF,FFFF00,FF0000";
      vram = true;

      fps = true;
      frame_timing = 10;
      font_size = 20;
      position = "top-left";
      io_read = true;
      io_write = true;
      ram = true;
      swap = true;
      engine_version = true;
      vulkan_driver = true;
      wine = true;
      output_folder = "${config.home.homeDirectory}/MangoHud";
      round_corners = 4;

      no_display = true;
      toggle_hud = "Alt_L+z";
    };
  };
}
