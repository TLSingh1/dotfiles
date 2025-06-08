{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Communication
    slack # Slack desktop client
    signal-dekstop
    # whatsapp-for-mac # WhatsApp desktop client

    # Media
    pavucontrol
    spotify
    # mpv # Video player
    # vlc # VLC media player

    # Graphics & Design
    # gimp # GNU Image Manipulation Program
    # inkscape # Vector graphics editor

    # Productivity
    # libreoffice # Office suite
    # obsidian # Note-taking app

    # System utilities
    # gnome.gnome-system-monitor # System monitor
    # gnome.gnome-disk-utility # Disk utility

    # Development
    # github-desktop # GitHub desktop client
    # postman # API development environment

    # File management
    # gnome.nautilus # File manager
    # thunar # Lightweight file manager

    # Internet
    google-chrome
    # thunderbird # Email client
    # qbittorrent # Torrent client
  ];
}
