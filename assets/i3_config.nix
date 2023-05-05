{ feh
, rofi-menugen
, writeScript
, rofi
, i3lock
, xbacklight
, xcape
, xset
, konsole
, i3-wallpaper
, shutter
, qt5
, lib
}:
let
  qdbus = "${lib.getDev qt5.qttools}/bin/qdbus";

  powerManagement = writeScript "rofi-power-management" ''
    #!${rofi-menugen}/bin/rofi-menugen
    #begin main
    prompt="Select:"
    add_exec 'Lock'         '${i3lock}/bin/i3lock'
    add_exec 'Sleep'        'systemctl suspend'
    add_exec 'Reboot'       'systemctl reboot'
    add_exec 'PowerOff'     'systemctl poweroff'
    add_exec 'Logout'       '${qdbus} org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.logout -1 -1 -1'
    #end main
  '';
  brigtnessManagement = writeScript "rofi-brigtness-management" ''
    #!${rofi-menugen}/bin/rofi-menugen
    #begin main
    prompt="Brigtness:"
    add_exec   "0" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 0"
    add_exec  "10" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 10"
    add_exec  "20" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 20"
    add_exec  "30" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 30"
    add_exec  "40" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 40"
    add_exec  "50" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 50"
    add_exec  "60" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 60"
    add_exec  "70" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 70"
    add_exec  "80" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 80"
    add_exec  "90" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 90"
    add_exec "100" "${xbacklight}/bin/xbacklight -time 500 -steps 30 -set 100"
    #end main
  '';

in
''
  set $mod Mod4

  set $gaps_inner 10
  set $gaps_outer 10

  #General settnings

  hide_edge_borders both
  for_window [class="^.*"] border pixel 0
  gaps inner $gaps_inner
  gaps outer $gaps_outer
  smart_gaps on

  # Font for window titles. Will also be used by the bar unless a different font
  # is used in the bar {} block below.
  # This font is widely installed, provides lots of unicode glyphs, right-to-left
  # text rendering and scalability on retina/hidpi displays (thanks to pango).
  #font pango:DejaVu Sans Mono 12
  font pango:SauceCodePro Nerd Font 12

  # Before i3 v4.8, we used to recommend this one as the default:
  # font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
  # The font above is very space-efficient, that is, it looks good, sharp and
  # clear in small sizes. However, its unicode glyph coverage is limited, the old
  # X core fonts rendering does not support right-to-left and this being a bitmap
  # font, it doesn’t scale on retina/hidpi displays.

  # Use Mouse+$mod to drag floating windows to their wanted position
  floating_modifier $mod

  # start a terminal
  bindsym $mod+Return exec ${konsole}/bin/konsole

  # kill focused window
  bindsym $mod+Shift+q kill

  # start dmenu (a program launcher)
  bindsym $mod+r exec ${rofi}/bin/rofi -show run -opacity 73 -hide-scrollbar -lines 4 -fuzzy

  bindsym $mod+space exec --no-startup-id ${rofi}/bin/rofi -fuzzy -show window
  #bindsym $mod+Shift+p exec --no-startup-id ${rofi}/bin/rofi -modi 1pass:rofi-1pass -show 1pass
  bindsym $mod+Shift+o exec --no-startup-id ${powerManagement}
  bindsym $mod+Shift+b exec --no-startup-id ${brigtnessManagement}

  # take screenshots
  bindsym Print         exec ${shutter}/bin/shutter --full
  bindsym Shift+Print   exec ${shutter}/bin/shutter --select

  # change focus
  bindsym $mod+j focus left
  bindsym $mod+k focus down
  bindsym $mod+l focus up
  bindsym $mod+semicolon focus right

  bindsym $mod+m move scratchpad
  bindsym $mod+o scratchpad show

  # alternatively, you can use the cursor keys:
  bindsym $mod+Left focus left
  bindsym $mod+Down focus down
  bindsym $mod+Up focus up
  bindsym $mod+Right focus right

  # move workspace to output right
  bindsym $mod+n move workspace to output right
  bindsym $mod+Shift+n move workspace to output left

  # move focused window
  bindsym $mod+Shift+j move left
  bindsym $mod+Shift+k move down
  bindsym $mod+Shift+l move up
  bindsym $mod+Shift+semicolon move right

  # alternatively, you can use the cursor keys:
  bindsym $mod+Shift+Left move left
  bindsym $mod+Shift+Down move down
  bindsym $mod+Shift+Up move up
  bindsym $mod+Shift+Right move right

  # split in horizontal orientation
  bindsym $mod+h split h

  # split in vertical orientation
  bindsym $mod+v split v

  # enter fullscreen mode for the focused container
  bindsym $mod+f fullscreen

  # change container layout (stacked, tabbed, toggle split)
  bindsym $mod+s layout stacking
  bindsym $mod+w layout tabbed
  bindsym $mod+e layout toggle split

  # toggle tiling / floating
  bindsym $mod+Shift+f floating toggle

  # change focus between tiling / floating windows
  #bindsym $mod+space focus mode_toggle

  # focus the parent container
  bindsym $mod+a focus parent

  # focus the child container
  #bindsym $mod+d focus child

  set $workspace1 "1"
  set $workspace2 "2"
  set $workspace3 "3"
  set $workspace4 "4"
  set $workspace5 "5"
  set $workspace6 "6"
  set $workspace7 "7"
  set $workspace8 "8"
  set $workspace9 "9"


  # switch to workspace
  bindsym $mod+1 workspace $workspace1
  bindsym $mod+2 workspace $workspace2
  bindsym $mod+3 workspace $workspace3
  bindsym $mod+4 workspace $workspace4
  bindsym $mod+5 workspace $workspace5
  bindsym $mod+6 workspace $workspace6
  bindsym $mod+7 workspace $workspace7
  bindsym $mod+8 workspace $workspace8
  bindsym $mod+9 workspace $workspace9

  # move focused container to workspace
  bindsym $mod+Shift+1 move container to workspace 1
  bindsym $mod+Shift+2 move container to workspace 2
  bindsym $mod+Shift+3 move container to workspace 3
  bindsym $mod+Shift+4 move container to workspace 4
  bindsym $mod+Shift+5 move container to workspace 5
  bindsym $mod+Shift+6 move container to workspace 6
  bindsym $mod+Shift+7 move container to workspace 7
  bindsym $mod+Shift+8 move container to workspace 8
  bindsym $mod+Shift+9 move container to workspace 9
  bindsym $mod+Shift+0 move container to workspace 10

  # set apps to specific workspaces

  assign [class="Chromium-browser"] $workspace2
  assign [class="Thunderbird"] $workspace1
  assign [class="Slack"] $workspace4
  assign [class="Spotify"] $workspace5

  # lock screen
  bindsym $mod+x exec '${i3lock}/bin/i3lock'

  # reload the configuration file
  bindsym $mod+Shift+c reload
  # restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
  bindsym $mod+Shift+r restart
  # exit i3 (logs you out of your X session)
  bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

  # resize window (you can also use the mouse for that)
  mode "resize" {
          # These bindings trigger as soon as you enter the resize mode

          # Pressing left will shrink the window’s width.
          # Pressing right will grow the window’s width.
          # Pressing up will shrink the window’s height.
          # Pressing down will grow the window’s height.
          bindsym j resize shrink width 10 px or 10 ppt
          bindsym k resize grow height 10 px or 10 ppt
          bindsym l resize shrink height 10 px or 10 ppt
          bindsym semicolon resize grow width 10 px or 10 ppt

          # same bindings, but for the arrow keys
          bindsym Left resize shrink width 10 px or 10 ppt
          bindsym Down resize grow height 10 px or 10 ppt
          bindsym Up resize shrink height 10 px or 10 ppt
          bindsym Right resize grow width 10 px or 10 ppt

          # back to normal: Enter or Escape
          bindsym Return mode "default"
          bindsym Escape mode "default"
  }

  bindsym $mod+b mode "resize"

  for_window [class="^.*"] border pixel 0
  for_window [class="Xfce4-notifyd"] floating enable

  client.focused #689d6a #689d6a #282828 #282828
  client.focused_inactive #1d2021 #1d2021 #928374 #282828
  client.unfocused #32302f #32302f #928374 #282828
  client.urgent #cc241d #cc241d #ebdbb2 #282828

  # Plasma compatibility improvements
  for_window [title="Desktop — Plasma"] kill; floating enable; border none
  for_window [window_role="pop-up"] floating enable
  for_window [window_role="task_dialog"] floating enable

  for_window [class="yakuake"] floating enable
  for_window [class="systemsettings"] floating enable
  for_window [class="plasmashell"] floating enable;
  for_window [class="Plasma"] floating enable; border none
  for_window [title="plasma-desktop"] floating enable; border none
  for_window [title="win7"] floating enable; border none
  for_window [class="krunner"] floating enable; border none
  for_window [class="Kmix"] floating enable; border none
  for_window [class="Klipper"] floating enable; border none
  for_window [class="Plasmoidviewer"] floating enable; border none
  for_window [class="(?i)*nextcloud*"] floating disable
  for_window [class="plasmashell" window_type="notification"] floating enable, border none, move right 700px, move down 450px, no_focus

  #
  # Solarized Light
  #
  set $base00 #fdf6e3
  set $base01 #eee8d5
  set $base02 #93a1a1
  set $base03 #839496
  set $base04 #657b83
  set $base05 #586e75
  set $base06 #073642
  set $base07 #002b36
  set $base08 #dc322f
  set $base09 #cb4b16
  set $base0A #b58900
  set $base0B #859900
  set $base0C #2aa198
  set $base0D #268bd2
  set $base0E #6c71c4
  set $base0F #d33682

  #
  # bar config
  #
  bar {
      status_command i3status
  
      colors {
          background $base00
          separator  $base01
          statusline $base04
  
          # State             Border  BG      Text
          focused_workspace   $base05 $base0D $base00
          active_workspace    $base05 $base03 $base00
          inactive_workspace  $base03 $base01 $base05
          urgent_workspace    $base08 $base08 $base00
          binding_mode        $base00 $base0A $base00
      }
  }

  #
  # Startup Applications
  #
  exec --no-startup-id ${xcape}/bin/xcape -e 'Control_L=Escape;Shift_R=parenright;Shift_L=parenleft'
  exec --no-startup-id ${feh}/bin/feh --bg-scale ${i3-wallpaper}
  exec --no-startup-id ${xset}/bin/xset r rate 200 50
''
