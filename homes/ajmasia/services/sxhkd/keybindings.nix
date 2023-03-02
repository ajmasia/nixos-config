{...}:

let
  userConfigPath = (import ../../global.nix).configHome;
in
{
  # Window manager control
  "super + alt + {q,r}" = "{bspc quit, ${userConfigPath}/bspwm/scripts/bspc_restart}";
  "super + Escape" = "pkill -USR1 -x sxhkd";

  # App launchers
  "super + {_,alt +}Return" = "{alacritty,open-floating-window alacritty}";
  "super + @space" = "rofi -show drun &";
  "super + shift + f" = "flameshot gui";

  # Scrachpads
  "super + shift + t" = "${userConfigPath}/bspwm/scripts/bspc_terminal-scrachpad";

  # Windows management
  "super + {_,shift + }w" = "bspc node -{c,k}";
  # alternate between the tiled and monocle layout
  "super + m" = "bspc desktop -l next";
  # send the newest marked node to the newest preselected node
  "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
  # swap the current node and the biggest window
  "super + g" = "bspc node -s biggest.window";
  # set the window state
  "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
  # focus or send to the given desktop
  "super + {1-9,0}" = "	bspc desktop -f {I,II,III,IV,V,VI,VII,VIII,IX,X}";
  # send and focus window to prev or next deskt 
  "super + shift + bracket{left,right}" = "bspc node -d {prev,next} -f";
  # focus history
  "super + {o,i}" = "bspc wm -h off; bspc node {older,newer} -f;bspc wm -h on;";
  # expand a window by moving one of its side outward
  "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
  # contract a window by moving one of its side inward
  "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
  # focus the node in the given direction
  "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
  # focus the node for the given path jump
  "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";

  # Desktops management
  "super + {Left,Right}" = "bspc desktop -f {prev,next}";

  # Brightness control
  "XF86MonBrightnessUp" = "brightnessctl s +1%";
  "XF86MonBrightnessDown" = "brightnessctl s 1%-";

  # Dunst control
  "super + shift + @space" = "dunstctl close";
  "super + shift + {n,d}" = "{dunstctl history-pop, toogle-dunst-status}";

  # Sound control
  "XF86Audio{Raise,Lower}Volume" = "vol {up,down}";
  "XF86AudioMute" = "vol mute";
}

