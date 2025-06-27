{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/wm/hyprland
    # Add other system-level modules here as needed
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use stable kernel (for NVIDIA driver compatibility)
  boot.kernelPackages = pkgs.linuxPackages;

  networking.hostName = "my-nixos";
  networking.networkmanager.enable = true;

  # Time zone
  time.timeZone = "America/Vancouver";

  # Internationalization
  i18n.defaultLocale = "en_CA.UTF-8";

  # Enable hardware graphics acceleration
  hardware.graphics.enable = true;

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Enable fingerprint support
  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  # Enable the X11 windowing system
  services.xserver.enable = true;

  # Enable NVIDIA drivers with Intel iGPU support
  services.xserver.videoDrivers = ["modesetting" "nvidia"];

  # Configure NVIDIA driver with PRIME offload
  hardware.nvidia = {
    open = false; # Use proprietary kernel modules

    prime = {
      offload.enable = true;
      offload.enableOffloadCmd = true; # Creates nvidia-offload command

      # PCI bus IDs - found using lspci
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };


  # Enable the GNOME Desktop Environment
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents
  services.printing.enable = true;

  # Enable sound with pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable fingerprint authentication for sudo, login, etc.
  security.pam.services.login.fprintAuth = true;
  security.pam.services.gdm-password.fprintAuth = true;
  security.pam.services.sudo.fprintAuth = true;

  # Define a user account
  users.users.tai = {
    isNormalUser = true;
    description = "tai";
    extraGroups = ["networkmanager" "wheel" "docker"];
    shell = pkgs.fish;
  };

  # Enable fish shell system-wide
  programs.fish.enable = true;

  # Install firefox
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flake Feature
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Enable Docker
  virtualisation.docker.enable = true;

  # System packages
  environment.systemPackages = with pkgs; [
    wget
    vim
    fish
    nodejs
  ];

  system.stateVersion = "25.05";
}
