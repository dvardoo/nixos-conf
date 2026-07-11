{ pkgs, ... }:

{
  # Aktiverar Niri-fönsterhanteraren globalt på systemet
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Installerar Noctalia och nödvändiga Wayland-verktyg
  environment.systemPackages = [
    pkgs.noctalia
    pkgs.xwayland
    pkgs.alacritty
  ];

  # Skriver grundinställningarna för Niri till din hemkatalog via Home Manager
  home-manager.users.dvardo = {
    xdg.configFile."niri/config.kdl".text = ''
      // Startar Noctalia-skalet automatiskt när Niri drar igång
      spawn-at-startup "noctalia"

      input {
          keyboard {
              xkb {
                  layout "se"
              }
          }
          touchpad {
              tap
              natural-scroll
          }
      }

      output "eDP-1" {
          mode "1920x1200@60.000"
          scale 1.0
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

      // Grundläggande tangentbordsgenvägar (Mod = Super/Windows-tangenten)
      binds {
          "Mod+Return" { spawn "alacritty"; }
          "Mod+D" { spawn "fuzzel"; }
          "Mod+Q" { close-window; }
          "Mod+Shift+E" { quit; }

          // Navigering mellan kolumner
          "Mod+Left"  { focus-column-left; }
          "Mod+Right" { focus-column-right; }

          // Flytta fönster
          "Mod+Shift+Left"  { move-window-column-left; }
          "Mod+Shift+Right" { move-window-column-right; }
      }
    '';
  };
}
