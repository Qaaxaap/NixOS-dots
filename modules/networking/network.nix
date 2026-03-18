{ config, lib, pkgs, self, ... } :

{
  networking.hostName = "Qaaxaap"; # Define your hostname.
  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;
  programs.clash-verge.enable = true;
  programs.clash-verge.tunMode = true;
  programs.clash-verge.serviceMode = true;
  networking.proxy.default = "http://127.0.0.1:7890";
  networking.search = [ "qaaxaap.github" ];
  # Open ports in the firewall.
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 7890 7891 7892 ];
  networking.firewall.allowedUDPPorts = [ 7890 7891 7892 ];
  networking.firewall.trustedInterfaces = [ "Meta" ];

  services.openssh.enable = true;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

}
