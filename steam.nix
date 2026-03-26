{ inputs, config, pkgs, lib, ... }:
{
  # 1. 启用 Steam 并自动配置环境
  programs.steam = {
    enable = true;
    # 如果玩需要联机的游戏，建议开启防火墙端口
    remotePlay.openFirewall = true;          # Steam 远程同乐
    dedicatedServer.openFirewall = true;     # 专用服务器
    localNetworkGameTransfers.openFirewall = true; # 局域网游戏传输
  };

  # 2. 允许安装 Steam 及其相关的非自由软件
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "steam" "steam-original" "steam-unwrapped" "steam-run"
  ];
  
  # 3. 关键：启用32位图形驱动支持（很多游戏是32位的）
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
