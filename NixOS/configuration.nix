# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      inputs.nixos-hardware.nixosModules.asus-zephyrus-gu603h
      #<nixos-hardware/asus/zephyrus/gu603h>
      ./hardware-configuration.nix
    ];
  
  #Experimental Options
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 5d";
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "shishu"; # Define your hostname.
#  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.nameservers = ["1.1.1.1"];
 
  #Enabling bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;  

  programs.ssh.startAgent = true;

  hardware.opentabletdriver.enable = true;
#  services.xserver.digimend.enable = true;
#  hardware.opentabletdriver.daemon.enable = true;
  #Asusctl and supergfxctl
  #services.supergfxd.enable = true;
  #systemd.services.supergfxd.path = [pkgs.pciutils];
 # services = {
  #  asusd = {
  #    enable = true;
  #    enableUserService = true;
  #  };
  #};
  #Thunderbolt
  services.hardware.bolt.enable = true;
  programs.steam.enable = true;
  programs.java.enable = true;
  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  
  boot.extraModulePackages = with config.boot.kernelPackages; [v4l2loopback];
  boot.kernelModules = ["v4l2loopback"];

  #VirtualBox
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["shishu"];

  #virt-manager 
  virtualisation.libvirtd = {
    enable = true;
  };
  programs.virt-manager.enable = true;
  # Select internationalisation properties.
#  i18n.defaultLocale = "en_US.UTF-8";
#  i18n.glibcLocales = lib.hiPrio (pkgs.buildPackages.glibcLocales.override {
 #   allLocales = lib.any (x: x == "all") config.i18n.supportedLocales;
 #   locales = config.i18n.supportedLocales;
  #}); 
 
  #Avahi
  services.avahi.enable = true;
  services.shairport-sync = {
    enable = true;
    openFirewall = true;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
 services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  #Fonts
  fonts.packages = with pkgs; [
    ipafont
    kochi-substitute
    dejavu_fonts
    noto-fonts-emoji
    noto-fonts-color-emoji
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji-blob-bin
    noto-fonts-monochrome-emoji
    nerdfonts
    lohit-fonts.marathi
    lohit-fonts.devanagari
    wqy_zenhei
  ];  
  fonts.fontDir.enable = true;
  fonts.fontconfig.enable = true;
  fonts.fontconfig.defaultFonts = {
    monospace = [
      "DejaVu Sans Mono"
      "IPAGothic"
    ];
    sansSerif = [
      "DejaVu Sans"
      "IPAPGothic"
    ];
    serif = [
      "DejaVu Serif"
      "IPAPMincho"
    ];
    emoji = [
      "Noto Color Emoji"
    ];
  };
 
  i18n.inputMethod = { 
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-mozc
      fcitx5-gtk
      fcitx5-rime
    ]; 
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # ervices.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.shishu = {
    isNormalUser = true;
    description = "shishu";
    extraGroups = [ "networkmanager" "wheel" "SharedUsers" ];
    packages = with pkgs; [
      firefox
      kate
      vim
      discord
      prismlauncher
      lshw
      gwenview
      krita
      zoom-us
      mindustry
      gitkraken
      libsForQt5.kdeconnect-kde
      transmission_4-qt
      unzip
      freetube
      handbrake
      inkscape
      davinci-resolve
      obs-studio
      jetbrains-toolbox
      rustup
      anki-bin
      ngrok
      zrok
      bore-cli
      gimp-with-plugins
      blender
      aseprite
      openttd
      openrct2
      vesktop
      obsidian
      mpv
    #  thunderbird
    ];
  };
  
  #users.users.logicle = {
  # isNormalUser = true;
  # description = "Logicle my friend";
  # extraGroups = ["networkmanager" "wheel" "SharedUsers"];
  # openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFMZps7X68lcEnxahmxD4jNq8r/I6Rnpaapu3pYXPpsh logicle-neutron" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOy8Blui/Q5EewzuoxyQd4qArZ1mJ9BH/wxIpFSv9Bs7 shishu@archlinux" ];
  # packages = with pkgs; [
  # ];
  #};

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cmake
    noto-fonts-cjk-sans
    spotify
    xclip
    musescore
    vscode
    git
    nodejs
    jdk17
    jdk21
    lutris
    gcc9
    playerctl
    lua-language-server
    libsForQt5.ksshaskpass
    libsForQt5.kdenlive
    libsForQt5.yakuake
    pkgs.nodePackages_latest.typescript-language-server
    tor-browser-bundle-bin
    wineWowPackages.stable
    wine
    (wine.override {wineBuild = "wine64"; })
    wineWowPackages.staging
    winetricks
    go
    sageWithDoc
    libreoffice-qt6-fresh
    p7zip
    wireguard-tools
    tmux
    inputs.muse-sounds-manager.packages.x86_64-linux.muse-sounds-manager
    uxplay
    avahi
    easyeffects
    bitwarden-desktop
    cargo
    rustc
    rustfmt
    rust-analyzer
    clippy
    ninja
 #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also iinstalled by default.
  #  wget
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
  };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  #Turn off Password AUth for SSh
  services.openssh.settings = {
    PasswordAuthentication = false;
    X11Forwarding = true;
    AllowTcpForwarding = true;
    X11UseLocalhost = true;
    X11DisplayOffset = 10;
  };
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
 # nativeBuildInputs = [pkg-config]; buildInputs = [systemd];
 # # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
  
  #nixpkgs.config.packageOverrides = pkgs: {
  #  intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  #};
  hardware.opengl = {
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      intel-compute-runtime
    ];
  };
  networking.extraHosts = ''
    142.197.100.154 logicle
  '';
  #Nvidia Config
  #hardware.opengl = {
  #  enable = true;
  #  driSupport = true;
  #  driSupport32Bit = true;
  #  extraPackages = with pkgs; [
 #     intel-media-driver
#      intel-vaapi-driver
 #     libvdpau-va-gl
 #   ];
 # };
 # environment.sessionVariables = {LIBVA_DRIVER_NAME = "iHD"; };
 # services.xserver.videoDrivers = ["nvidia" "intel"];
#  hardware.nvidia = {
  #  modesetting.enable = true;
  #  powerManagement.enable = false;
  #  powerManagement.finegrained = false;
  #  open = false;
  #  nvidiaSettings = true;
  #  package = config.boot.kernelPackages.nvidiaPackages.stable;
  #};
  #boot.initrd.kernelModules = [ "nvidia" ];
  #boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];
  #hardware.nvidia.prime = {
  #  intelBusId = "PCI:0:2:0";
  #  nvidiaBusId = "PCI:1:0:0";
  #};
#  boot.kernelParams = [ "i915.force_probe=9a49" ];
  services.fwupd.enable = true;
  #fileSystems."/mnt/Backup" = {
  #  device = "10.0.0.20:/home/shishu/Backup";
  #  fsType = "nfs";
  #  options = ["x-systemd.automount" "noauto"];
  #};
  
#for wireguard
  #networking.firewall.checkReversePath = false;
  
}
