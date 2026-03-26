{ config, lib, pkgs, ... }:

let
  deviceId = "7d55";  # 你的 Intel Arc 设备 ID
in
{
  boot = {
    kernelParams = [
      "i915.force_probe=!${deviceId}"
      "xe.force_probe=${deviceId}"
      "i915.enable_guc=3"
    ];
  };

  services.xserver.videoDrivers = [ "modesetting" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      intel-media-driver
      vpl-gpu-rt
      intel-compute-runtime
    ];
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };
}
