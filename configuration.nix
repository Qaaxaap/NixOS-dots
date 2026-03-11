# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, self , ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";
  };
  boot.loader.efi.efiSysMountPoint = "/efi";
  # boot.loader.efi.bootloaderId = "NixOS";
  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "Qaaxaap"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

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
  networking.proxy.default = "http://127.0.0.1:7890";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  fonts.packages = with pkgs; [
    self.packages.${pkgs.system}.space-grotesk
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "kvm" ];
    packages = with pkgs; [];
  };

  programs.firefox.enable = true;
  services.flatpak.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    ntfs3g
    wget
    art
    bkcrack
    fastfetch
    pywalfox-native
    os-prober
    kitty
    cpeditor
    git
    perl
    gparted
    cargo
    qq 
    killall
    gcc
    clang
    brightnessctl
    gdb
    cmake
    ninja
    meson
    baidupcs-go
    zip
    inetutils
    vscode
    vlc
    valgrind
    cppcheck
    clang-tools
    # clash-verge-rev
    mihomo
    neovim
    # gui-for-clash
    gnumake
    ripgrep
    fd 
    hmcl
    unzip
    nodejs_25
    kdePackages.krdc
    lazygit
    fzf
    ghostscript
    tectonic
    mermaid-cli
    tree-sitter
    pipewire
    xwayland-satellite
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.qt6ct
    kdePackages.kpipewire
    libsForQt5.kirigami2
    libsForQt5.kirigami-addons
    virt-viewer
    libguestfs-with-appliance
    spice spice-gtk
    spice-protocol
    dnsmasq
    docker
    qbittorrent
    quickemu
    qemu
    xdg-desktop-portal
  ];

  environment.sessionVariables = {
    GTK_USE_PORTAL = "1";
    NIXOS_OZONE_WL = "1";
  };

  nixpkgs.config.allowUnfree = true;
  services.dbus.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk  
    # xdg-desktop-portal-kde
    xdg-desktop-portal
  ];

  services.openssh.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  networking.firewall.enable = false;
  networking.firewall.allowedTCPPorts = [ 7890 7891 7892 ];
  networking.firewall.allowedUDPPorts = [ 7890 7891 7892 ];
  networking.firewall.trustedInterfaces = [ "Meta" ];

  services.spice-vdagentd.enable = true;

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
