{ pkgs, winapps,... }: 
{
  environment.systemPackages = with pkgs; [
    winapps.packages.${pkgs.system}.winapps
  ];
}
