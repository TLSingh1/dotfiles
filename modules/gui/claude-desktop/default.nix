{ config, pkgs, lib, inputs, ... }:

{
  # Allow unfree packages for Claude Desktop
  nixpkgs.config.allowUnfree = true;
  
  home.packages = [
    # Claude Desktop - AI assistant application
    # Use claude-desktop-with-fhs if you need MCP server support with npx, uvx, or docker
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop
    
    # Alternative with FHS environment for MCP servers:
    # inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
  ];
} 