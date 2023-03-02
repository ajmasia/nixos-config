{ ... }:

{
  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        WINIT_X11_SCALE_FACTOR = "1.05";
      };

      class = {
        instance = "Alacritty";
        general = "Alacritty";
      };

      font = {
        size = 12;

        normal = {
          family = "Hack Nerd Font";
        };
      };

      colors = {
        primary = {
          background = "#24283b";
          foreground = "0xa9b1d6";
        };

        selection = {
          background = "#444444";
          text = "#c5c8c6";
        };

        cursor = {
          cursor = "#d0d0d0";
          text = "#151515";
        };

        normal = {
          black = "0x32344a";
          blue = "0x7aa2f7";
          cyan = "0x449dab";
          green = "0x9ece6a";
          magenta = "0xad8ee6";
          red = "0xf7768e";
          white = "0x787c99";
          yellow = "0xe0af68";
        };

        bright = {
          black = "0x444b6a";
          blue = "0x7da6ff";
          cyan = "0xbb9af7";
          green = "0xb9f27c";
          magenta = "0xbb9af7";
          red = "0xff7a93";
          white = "0xacb0d0";
          yellow = "0xff9e64";
        };
      };

      window = {
        padding = { x = 8; y = 8; };
      };

      cursor = {
        blink_interval = 750;
        unfocused_hollow = false;

        style = {
          shape = "underline";
          blinking = "always";
        };
      };

      shell = {
        program = "/run/current-system/sw/bin/bash";
      };
    };
  };
}

