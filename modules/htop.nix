{ config, pkgs, ... }:

{
  programs.htop = {
    enable = true;

    settings = {
      hide_kernel_threads = true;
      hide_userland_threads = true;
      shadow_other_users = true;
      highlight_base_name = true;
      highlight_deleted_exe = true;
      shadow_distribution_path_prefix = true;
      highlight_changes = true;
      highlight_changes_delay_secs = 1;
      screen_tabs = false;
      enable_mouse = true;
      delay = 10;
      tree_view = true;

      fields = with config.lib.htop.fields; [
        PID USER PRIORITY STATE STARTTIME M_RESIDENT PERCENT_CPU TIME COMM
      ];

      header_layout = "two_33_67";
    } // (with config.lib.htop; leftMeters [
      (text "Hostname")
      (text "Uptime")
      (text "LoadAverage")
      (text "Tasks")
      (text "DiskIO")
      (text "NetworkIO")
      (text "SELinux")
      (text "Systemd")
    ]) // (with config.lib.htop; rightMeters [
      (bar "AllCPUs4")
      (bar "Memory")
      (bar "Zram")
    ]);
  };
}
