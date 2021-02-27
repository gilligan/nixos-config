{ config, lib, pkgs, ... }:
{
  systemd.services = {
    assetupnp = {
      description = "Asset UPnP";
      after = [ "network.target" "run-media-gilligan-Elements.mount" ];
      enable = true;
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        User = "gilligan";
        ExecStart = "${pkgs.assetupnp}/bin/AssetUPnP";
        ExecStop = "${pkgs.assetupnp}/bin/AssetUPnP --shutdown";
      };
    };
  };
}
