{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # System info
    neofetch
    macchina

    # File management
    yazi

    # Archives
    zip
    xz
    unzip
    p7zip

    # Utils
    ripgrep
    jq
    yq-go
    eza
    fzf
    bat  # for fish aliases and functions
    zoxide
    wev
    wlr-randr

    # Development tools
    rustc
    cargo
    claude-code
    gh
    meson

    # Networking tools
    mtr
    iperf3
    dnsutils
    ldns
    aria2
    socat
    nmap
    ipcalc

    # Misc
    cmatrix
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # Productivity
    glow
    btop
    iotop # io monitoring
    iftop # network monitoring

    # System call monitoring
    strace # sys call monitoring
    ltrace # lib call monitoring
    lsof # list open files

    # System tools
    sysstat
    lm_sensors
    ethtool
    pciutils
    usbutils
  ];
} 
