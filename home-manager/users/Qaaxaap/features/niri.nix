{ config, lib, pkgs, ... }:
{
  programs = {
    niri = {
      settings = {
        hotkey-overlay = {
          skip-at-startup = true;
        };
      };
    };
  };
}
