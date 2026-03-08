{ pkgs, inputs, ... }:
let
  noctalia = cmd: [
    "noctalia-shell" "ipc" "call"
  ] ++ (pkgs.lib.splitString " " cmd);
in
{
  nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  programs.niri.package = pkgs.niri;
  imports = [ inputs.niri.nixosModules.niri ];
  niri-flake.cache.enable = true;
  programs.niri.enable = true;
  home-manager.users.Qaaxaap = 
    { config, lib, ... }:
    {
     #  home.sessionVariables = { QT_QPA_PLATFORMTHEME = "kde"; }; 
      programs = {
        niri = {
          settings = {
            hotkey-overlay = {
              skip-at-startup = true;
            };
            prefer-no-csd = true;
            window-rules = [
              {
                clip-to-geometry = true;
                geometry-corner-radius = {
                  bottom-left = 12.0;
                  bottom-right = 12.0;
                  top-left = 12.0;
                  top-right = 12.0;
                };
              }
            ];
            layout = {
              default-column-width = {};
              preset-column-widths = [
                { proportion = 1. / 3.; }
              { proportion = 1. / 2.; }
              { proportion = 2. / 3.; }
              ];
            };
            outputs = {
              eDP-1 = {
                mode = {
                  width = 3072;
                  height = 1920;
                };
                scale = 2;
              };
            };
            spawn-at-startup = [
              {
                command = [
                "noctalia-shell"
              ];
              }
            ];
            binds = with config.lib.niri.actions; {
              "Mod+Return".action.spawn = "kitty";
              "Mod+Shift+Slash".action.spawn = "show-hotkey-overlay";
              "Mod+Shift+S".action.screenshot = { show-pointer=false; };
              "Mod+A".action.spawn = noctalia "launcher toggle";
              "Mod+D".action.spawn = "dolphin";
              "Mod+W".action.spawn = "firefox";
              "Mod+L".action.spawn = noctalia "lockScreen lock";
              "XF86AudioRaiseVolume".action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1+";
              "XF86AudioLowerVolume".action.spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.1-";
              "XF86AudioMute".action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
              "XF86AudioMicMute".action.spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle";
              "XF86MonBrightnessUp".action.spawn-sh = "brightnessctl set +10%";
              "XF86MonBrightnessDown".action.spawn-sh = "brightnessctl set 10%-";
              "Mod+Minus".action.set-window-width = "-1%";
              "Mod+Equal".action.set-window-width = "+1%";
              "Mod+Q" = { repeat = false; action.close-window = []; };
              "Mod+Tab" = { repeat = false; action.toggle-overview = []; };
              "Mod+Left".action.focus-column-left = [];
              "Mod+Right".action.focus-column-right = [];
              "Mod+Up".action.focus-window-up = [];
              "Mod+Down".action.focus-window-down = [];
              "Mod+Page_Up".action.focus-workspace-up = [];
              "Mod+Page_Down".action.focus-workspace-down = [];
              "Mod+R".action.switch-preset-column-width = [];
              "Mod+F".action.expand-column-to-available-width = [];
              "Mod+Shift+F".action.fullscreen-window = [];
              "Mod+H".action.toggle-column-tabbed-display = [];
            };
            environment = {
              QT_QPA_PLATFORMTHEME = "qt6ct";
              ALL_PROXY = "http://127.0.0.1:7890";
              LANG = "zh_CN.UTF-8";
              LC_CTYPE = "zh_CN.UTF-8";
              LC_NUMERIC = "zh_CN.UTF-8";
              LC_TIME = "zh_CN.UTF-8";
              LC_COLLATE = "zh_CN.UTF-8";
              LC_MONETARY = "zh_CN.UTF-8";
              LC_MESSAGES = "zh_CN.UTF-8";
              LC_PAPER = "zh_CN.UTF-8";
              LC_NAME = "zh_CN.UTF-8";
              LC_ADDRESS = "zh_CN.UTF-8";
              LC_TELEPHONE = "zh_CN.UTF-8";
              LC_MEASUREMENT = "zh_CN.UTF-8";
              LC_IDENTIFICATION = "zh_CN.UTF-8";
              LC_ALL = null;
              # XDG_DATA_DIRS "$HOME/.local/share" "$XDG_DATA_DIRS"
              QT_IM_MODULE = "fcitx";
              # https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland#Sway
              XMODIFIERS = "@im=fcitx";
              QT_IM_MODULES = "wayland;fcitx";
              GTK_IM_MODULE = null;
              SDL_IM_MODULE = null;
              GLFW_IM_MODULE = null;
              ICON_THEME = "breeze";
              GTK_THEME = "Breeze";
              XCURSOR_THEME = "breeze_cursors";
              XDG_DATA_DIRS = "/run/current-system/sw/share:$XDG_DATA_DIRS";
            };
          };
        };
      };
    };
}
