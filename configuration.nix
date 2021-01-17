# Help is available in the configuration.nix(5) man page and in the
# NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # applications
    discord
    emacs
    firefox
    slack
    spotify
    steam
    # programming environments
    leiningen  # Clojure
    openjdk8   # JVM
    # CLI tools
    ack
    ag  # TODO: pick one between ack/ag, I have machines that use each because of melpa
    docker
    git
    lsof
    # existing in the OS
    pulseaudio
    redshift
  ];
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
    grub.useOSProber = true;
  };

  # Saint Louis, Missouri
  time.timeZone = "America/Chicago";
  location = {  # for redshift
    latitude = 38.6;
    longitude = 90.2;
  };

  # Required for Steam
  hardware.opengl.driSupport32Bit = true;

  # Required for Docker
  virtualisation.docker.enable = true;

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.wlp1s0.useDHCP = true;
    networkmanager.enable = true;

    # hostName = "nixos"; # Define your hostname.
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  services = {
    # Enable the OpenSSH daemon.
    # openssh.enable = true;

    # Enable CUPS to print documents.
    # printing.enable = true;

    redshift = {
      enable = true;
      temperature = {
        day = 6400;
        night = 4600;
      };
    };

    xserver = {
      enable = true;
      # Enable the GNOME 3 Desktop Environment.
      desktopManager.gnome3.enable = true;
      displayManager.gdm.enable = true;

      # Configure keymap in X11
      # layout = "us";
      # xkbOptions = "eurosign:e";

      # Enable touchpad support (enabled default in most desktopManager).
      # libinput.enable = true;
    };
  };

  # Enable sound.
  sound.enable = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  users.users.john = {
    isNormalUser = true;
    home = "/home/john";
    extraGroups = [
      "audio"  # Enable audio devices for the user
      "docker"  # BEWARE that the docker group membership is effectively equivalent to being root!
      "networkmanager"
      "wheel"  # Enable 'sudo' for the user
    ];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}
