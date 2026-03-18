{ config, pkgs, ... }:
{
    home.file.".p10k.zsh".source = ../../dotfiles/p10k.zsh;
    home.packages = with pkgs; [
      zsh-powerlevel10k
    ];
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      oh-my-zsh = {
        enable = true;
        plugins = [ "git" "sudo" ];
        theme = "";
      };
    };
}
