{ config, pkgs, ... }:
{
  programs.zsh.enable = true;
  users.users.Qaaxaap = {
    shell = pkgs.zsh;
  };
  environment.shells = with pkgs; [ bash zsh ];
  users.defaultUserShell = pkgs.zsh;
}
