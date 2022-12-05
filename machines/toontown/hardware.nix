# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
      <nixpkgs/nixos/modules/installer/scan/not-detected.nix>
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    cryptkey = {
      device = "/dev/disk/by-uuid/bbe54b27-5469-44f8-9f92-3244904c76be";
    };

    cryptroot = {
      device = "/dev/disk/by-uuid/0ea87364-ad0c-4649-a46d-17b90c27da30";
      keyFile = "/dev/mapper/cryptkey";
    };

    cryptswap = {
      device = "/dev/disk/by-uuid/228ff136-652f-47ed-81bd-d5619c3785b5";
      keyFile = "/dev/mapper/cryptkey";
    };
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/113f7949-1b5e-4f28-b8ab-d1465ad467b0";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/FBC6-B75D";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/3b57f9a5-796f-4655-a36e-c33c8b4193c7"; }];

  nix.settings.max-jobs = lib.mkDefault 32;
  # High-DPI console
  console.font = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";
}
