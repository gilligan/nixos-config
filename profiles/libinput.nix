{ config, lib, pkgs, ... }:
{
  services = {
    xserver = {
      libinput = {
        enable = true;
        tapping = false;
        clickMethod = "clickfinger";
        disableWhileTyping = true;
        scrollMethod = "twofinger";
        naturalScrolling = true;
      };
    };
  };
}
