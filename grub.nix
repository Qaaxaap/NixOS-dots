{ inputs, config, pkgs, lib, ... }:
{
#boot.loader.grub2-theme = {
#    enable = false;
#    theme = "stylish";
#    footer = true;
#    customResolution = "3072x1920";
#  };
  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
    useOSProber = true;
  };
  boot.loader.efi.efiSysMountPoint = "/efi";
}
