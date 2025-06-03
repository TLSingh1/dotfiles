{ config, pkgs, lib, inputs, ... }:

{
  home.packages = [
    # Claude Desktop with FHS environment for MCP server support
    # This allows running MCP servers with npx, uvx, or docker
    inputs.claude-desktop.packages.${pkgs.system}.claude-desktop-with-fhs
    
    # Basic version without MCP support:
    # inputs.claude-desktop.packages.${pkgs.system}.claude-desktop
  ];
} 