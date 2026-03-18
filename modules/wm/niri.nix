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
  niri-flake.cache.enable = false;
  programs.niri.enable = true;
}
