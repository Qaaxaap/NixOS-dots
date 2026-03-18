{ config, pkgs, ... }:

let
  originalTheme = pkgs.sddm-astronaut;          # 原主题包
  profileDir = ./sddm;                   # 你的自定义文件目录
  
  myTheme = pkgs.runCommand "sddm-astronaut-custom" {
    buildInputs = [ profileDir ];
  } ''
    mkdir -p $out/share/sddm/themes/sddm-astronaut-theme
    cp -r ${originalTheme}/share/sddm/themes/sddm-astronaut-theme/* $out/share/sddm/themes/sddm-astronaut-theme/
    chmod +w -R $out/share/sddm/themes/sddm-astronaut-theme

    if [ -d "${profileDir}" ]; then
      echo "Applying custom files from ${profileDir}..."
      # 使用 / 确保复制目录内容，并强制覆盖
      cp -rf ${profileDir}/. $out/share/sddm/themes/sddm-astronaut-theme/

      # 调试：打印覆盖后的 metadata.desktop 内容
      echo "After overlay, metadata.desktop contains:"
      cat $out/share/sddm/themes/sddm-astronaut-theme/metadata.desktop || echo "File not found"
    else
      echo "Warning: ${profileDir} not found, using original theme only."
    fi
  '';
in
{
  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs.kdePackages; [ qt5compat qtmultimedia ];
  };

  services.fprintd.enable = true;
  security.pam.services.sddm.fprintAuth = true;

  environment.systemPackages = [ myTheme ];
  services.desktopManager.plasma6.enable = true;
}
