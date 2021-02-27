{ config, lib, pkgs, ... }:
{
  systemd.mounts = [
    {
      what = "/dev/sda2";
      type = "exfat";
      where = "/run/media/gilligan/Elements";
      options = "rw,nosuid,nodev,relatime,uid=1000,gid=100,fmask=0022,dmask=0022,iocharset=utf8,namecase=0,errors=remount-ro";
      description = "asset upnp music source";
      wantedBy = [ "multi-user.target" ];
    }
  ];
}
