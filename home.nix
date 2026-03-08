{ config, pkgs, ... }:

{
  home-manager.users.Qaaxaap = { config, pkgs, ... }: {
    nixpkgs.config.allowUnfree = true;
    xdg.dataFile."applications/qq.desktop".text = ''
      [Desktop Entry]
      Name=QQ
      Exec=qq --ozone-platform=wayland --enable-wayland-ime --wayland-text-input-version=3 %U
      Terminal=false
      Type=Application
      Icon=${pkgs.qq}/share/icons/hicolor/512x512/apps/qq.png
      StartupWMClass=QQ
      Categories=Network;
      Comment=QQ
    '';
    home.file.".config/nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/Qaaxaap/nixos/nvim-dots";
      recursive = true;
    };
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Qaaxaap";
          email = "lkn15289353760@126.com";
        };
        init = {
          defaultBranch = "main";
        };
      };
    };
  };
}
