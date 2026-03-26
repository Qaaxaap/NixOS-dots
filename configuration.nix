# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, self , ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader. in ./grub.nix
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";
  
  services.fprintd.enable = true;

  nix.settings = {
    substituters = [
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store?priority=10"
      "https://mirrors.ustc.edu.cn/nix-channels/store?priority=5"
      "https://cache.nixos.org"
    ];
    experimental-features = [ "nix-command" "flakes" ];
  };

  fonts.packages = with pkgs; [
    self.packages.${pkgs.system}.space-grotesk
  ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  environment.etc."xdg/menus/applications.menu".source = 
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.Qaaxaap = {
    isNormalUser = true;
    description = "Qaaxaap";
    extraGroups = [ "networkmanager" "wheel" "kvm" "video" "plugdev"];
    packages = with pkgs; [];
  };

  hardware.opengl = {
    enable = true;
# driSupport = true;
  };
  hardware.enableRedistributableFirmware = true;

  programs.firefox.enable = true;
  services.flatpak.enable = true;
  services.tailscale.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = 
    (with pkgs; [
      clang-tools clang cargo gcc gdb cmake ninja meson cppcheck gnumake fd nodejs_25 fzf ghostscript tectonic tree-sitter
      neovim vim git wget ntfs3g kitty killall perl zip bkcrack fastfetch brightnessctl inetutils tailscale ripgrep unzip lazygit mermaid-cli dnsmasq
      art qq pywalfox-native gparted vlc vscode valgrind mihomo hmcl xwayland-satellite pipewire qbittorrent
      libguestfs-with-appliance xdg-desktop-portal
      spice spice-gtk spice-protocol quickemu qemu virt-viewer
      wineWow64Packages.yabridge winetricks
      libreoffice-qt-fresh
    ]) ++
    (with pkgs.kdePackages; [ qt6ct kpipewire filelight]) ++
    (with pkgs.llvmPackages_latest; [ libcxx libllvm clang ]);
  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
  };

  nixpkgs.config.allowUnfree = true;
  services.dbus.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk  
    xdg-desktop-portal
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.spice-vdagentd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", MODE="0666"
  '';
  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  home-manager.users.Qaaxaap = { pkgs, ... }: {
    home.stateVersion = "25.11";  
    home.packages = [ ] ;
  };
  system.stateVersion = "25.11"; # Did you read the comment?
}
