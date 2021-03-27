self: super:
{
  i3-wallpaper = self.copyPathToStore ../assets/wallpaper.png;

  i3-config = import ../assets/i3_config.nix {
    inherit (self) qt5 lib;
    inherit (self) feh rofi-menugen;
    inherit (self) rofi i3lock xcape;
    inherit (self) writeScript;
    inherit (self.xorg) xbacklight xset;
    inherit (self) i3-wallpaper;
    inherit (self) shutter konsole;
  };

  i3-config-file = self.writeTextFile {
    name = "i3.conf";
    text = self.i3-config;
  };

}
