{ pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        title = "Alacritty";
        dynamic_title = true;
        decorations = "none"; # "full", "none", "transparent", "buttonless"

        padding = {
          x = 10;
          y = 10;
        };
      };

      cursor = {
        style = {
          shape = "Block"; # "Block" "Underline", "Beam"
          blinking = "Off"; # "Always", "Off", "On"
        };
      };

      mouse = {
        bindings = [
          {
            mouse = "Right";
            action = "Copy";
          }
        ];
      };
    };
  };
}
