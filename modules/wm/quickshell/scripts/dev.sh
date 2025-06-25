#!/usr/bin/env bash

# Quickshell Cyberpunk Development Script

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Directories
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MODULE_DIR="$(dirname "$SCRIPT_DIR")"
SHELL_DIR="$MODULE_DIR/shell"

echo -e "${BLUE}🚀 Quickshell Cyberpunk Development Environment${NC}"
echo

# Function to print usage
usage() {
    echo "Usage: $0 [command]"
    echo
    echo "Commands:"
    echo "  run       Start quickshell with hot reload"
    echo "  test      Run quickshell in test mode"
    echo "  theme     Extract theme from wallpaper"
    echo "  logs      Show quickshell logs"
    echo "  restart   Restart the systemd service"
    echo "  help      Show this help message"
}

# Check if quickshell is available
check_quickshell() {
    if ! command -v quickshell &> /dev/null; then
        echo -e "${RED}Error: quickshell not found. Make sure the module is enabled in your configuration.${NC}"
        exit 1
    fi
}

# Run with hot reload
run_dev() {
    echo -e "${GREEN}Starting Quickshell with hot reload...${NC}"
    echo -e "${YELLOW}Save any QML file to reload${NC}"
    echo
    
    cd "$SHELL_DIR"
    
    # Kill any existing quickshell instances
    pkill -f "quickshell.*cyberpunk" || true
    
    # Start with hot reload
    exec quickshell-dev
}

# Test mode
test_mode() {
    echo -e "${GREEN}Running Quickshell in test mode...${NC}"
    
    cd "$SHELL_DIR"
    
    # Kill any existing instances
    pkill -f "quickshell.*cyberpunk" || true
    
    # Run with verbose output
    QSG_INFO=1 quickshell -c cyberpunk
}

# Extract theme
extract_theme() {
    if [ -z "$1" ]; then
        echo -e "${YELLOW}Usage: $0 theme <wallpaper_path>${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}Extracting theme from: $1${NC}"
    quickshell-extract-theme "$1"
}

# Show logs
show_logs() {
    echo -e "${GREEN}Showing Quickshell logs...${NC}"
    journalctl --user -u quickshell-cyberpunk -f
}

# Restart service
restart_service() {
    echo -e "${GREEN}Restarting Quickshell service...${NC}"
    systemctl --user restart quickshell-cyberpunk
    echo -e "${GREEN}Done!${NC}"
}

# Main command handling
case "${1:-run}" in
    run)
        check_quickshell
        run_dev
        ;;
    test)
        check_quickshell
        test_mode
        ;;
    theme)
        check_quickshell
        extract_theme "$2"
        ;;
    logs)
        show_logs
        ;;
    restart)
        restart_service
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo -e "${RED}Unknown command: $1${NC}"
        usage
        exit 1
        ;;
esac