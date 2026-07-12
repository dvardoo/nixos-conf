{ pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  environment.systemPackages = [
    pkgs.noctalia-shell
    pkgs.alacritty
    pkgs.fuzzel
  ];

  home-manager.users.dvardo = {
    xdg.configFile."niri/config.kdl".text = ''
      // Startup
      spawn-at-startup "noctalia-shell"

      input {
          keyboard {
              xkb {
                  layout "se"
              }
          }
          touchpad {
              tap
          }
      }

      output "eDP-1" {
          mode "1920x1200@60.000"
          scale 1.0
      }

      output "DP-3" {
          mode "2560x1440@60.000"
          position x=0 y=0
          transform "normal"
      }

      output "DP-5" {
          mode "1080x1920@60"
          position x=2560 y=0
          transform "270"
      }

      layout {
          gaps 8
          center-focused-column "never"

          preset-column-widths {
              proportion 0.33333
              proportion 0.5
              proportion 0.66667
          }

          default-column-width { proportion 0.5; }
      }

      // Shortcuts
      binds {
          // Spawn
          "Mod+T" { spawn "alacritty"; }
          "Mod+D" { spawn "fuzzel"; }
          "Mod+Q" { close-window; }
          "Mod+H" { show-hotkey-overlay; }
          "Mod+Shift+E" { quit; }

          // Navigation
          "Mod+Left"  { focus-column-left; }
          "Mod+Right" { focus-column-right; }
          "Mod+Up"     { focus-window-up; }
          "Mod+Down"   { focus-window-down; }

          // Window management
          "Mod+Shift+Left"  { move-column-left; }
          "Mod+Shift+Right" { move-column-right; }
          "Mod+Shift+Up"    { move-window-up; }
          "Mod+Shift+Down"  { move-window-down; }

          // Stacks & Layout
          "Mod+S" { toggle-column-tabbed-display; }
          "Mod+M" { maximize-column; }
          "Mod+Ctrl+M" { fullscreen-window; }
          "Mod+W" { toggle-column-tabbed-display; }

          // Workspaces
          "Mod+1" { focus-workspace 1; }
          "Mod+2" { focus-workspace 2; }
          "Mod+3" { focus-workspace 3; }
          "Mod+Shift+1" { move-column-to-workspace 1; }
          "Mod+Shift+2" { move-column-to-workspace 2; }
          "Mod+Shift+3" { move-column-to-workspace 3; }
          "Mod+Ctrl+1" { move-column-to-workspace 1; }
          "Mod+Ctrl+2" { move-column-to-workspace 2; }
          "Mod+Ctrl+3" { move-column-to-workspace 3; }

          // Column/Window adjustments
          "Mod+Minus" { set-column-width "-10%"; }
          "Mod+Plus" { set-column-width "+10%"; }
          "Mod+Shift+Minus" { set-window-height "-10%"; }
          "Mod+Shift+Plus" { set-window-height "+10%"; }

          // Floating
          "Mod+V" { toggle-window-floating; }

          // System
          "Mod+O" { toggle-overview; }
      }
    '';
  };
}
