{ config, pkgs, lib, ... }:
{
  home-manager.users.Qaaxaap = { config, pkgs, ... }: {
    home.sessionVariables = {
      NIXPKGS_QT6_QML_IMPORT_PATH = "${pkgs.kdePackages.kirigami.unwrapped}/lib/qt-6/qml"; 
      QT_QPA_PLATFORMTHEME = "kde"; 
      PATH = lib.concatStringsSep ":" [
        "$HOME/.local/bin"
        "$HOME/.nix-profile/bin"
        "/etc/profiles/per-user/Qaaxaap/bin"
        "/run/wrappers/bin"
        "/run/current-system/sw/bin"
        "$HOME/.local/share/flatpak/exports/bin"
        "/var/lib/flatpak/exports/bin"
        "/nix/var/nix/profiles/default/bin"
        "/usr/bin"
      ];
    };
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
    home.file.".config/xdg-desktop-portal" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/Qaaxaap/nixos/xdg-desktop-portal";
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
