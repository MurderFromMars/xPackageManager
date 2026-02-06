#!/bin/bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }

clear
echo -e "${CYAN}${BOLD}"
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║         xPackageManager - Universal Arch Edition              ║"
echo "║         Works on ALL Arch-based distributions!                ║"
echo "╚═══════════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# Check for root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run as root. The script will request sudo when needed."
    exit 1
fi

# Check for Arch-based system
if [ ! -f /etc/arch-release ] && ! command -v pacman &> /dev/null; then
    print_error "This package manager is designed for Arch-based systems only!"
    exit 1
fi

# Check dependencies
print_info "Checking build dependencies..."
MISSING_DEPS=()

for dep in rust cargo qt6-base qt6-declarative pacman flatpak; do
    if ! pacman -Q $dep &>/dev/null; then
        MISSING_DEPS+=("$dep")
    fi
done

if [ ${#MISSING_DEPS[@]} -gt 0 ]; then
    print_info "Installing missing dependencies: ${MISSING_DEPS[*]}"
    sudo pacman -S --needed --noconfirm "${MISSING_DEPS[@]}"
fi

print_success "All dependencies installed"
echo ""

# Build the project
print_info "Building xPackageManager (this may take a few minutes)..."
if ! cargo build --release; then
    print_error "Build failed!"
    exit 1
fi

print_success "Build completed successfully"
echo ""

# Install the binary
print_info "Installing xPackageManager..."
sudo mkdir -p /opt/xpackagemanager
sudo cp target/release/xpm-ui /opt/xpackagemanager/xpackagemanager
sudo chmod +x /opt/xpackagemanager/xpackagemanager

# Create wrapper script
print_info "Creating launcher..."
sudo tee /usr/bin/xpackagemanager > /dev/null << 'EOF'
#!/bin/bash
exec /opt/xpackagemanager/xpackagemanager "$@"
EOF
sudo chmod +x /usr/bin/xpackagemanager

# Install desktop files
print_info "Installing desktop integration..."

if [ -d packaging ]; then
    # Install desktop file
    if [ -f packaging/xpackagemanager.desktop ]; then
        sudo install -Dm644 packaging/xpackagemanager.desktop \
            /usr/share/applications/xpackagemanager.desktop
    fi
    
    # Install MIME type
    if [ -f packaging/x-alpm-package.xml ]; then
        sudo install -Dm644 packaging/x-alpm-package.xml \
            /usr/share/mime/packages/x-alpm-package.xml
    fi
    
    # Install polkit policy
    if [ -f packaging/org.xpackagemanager.policy ]; then
        sudo install -Dm644 packaging/org.xpackagemanager.policy \
            /usr/share/polkit-1/actions/org.xpackagemanager.policy
    fi
fi

# Update databases
print_info "Updating system databases..."
sudo update-desktop-database /usr/share/applications 2>/dev/null || true
sudo update-mime-database /usr/share/mime 2>/dev/null || true

echo ""
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}${BOLD}  Installation Complete!${NC}"
echo -e "${GREEN}${BOLD}════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${CYAN}Launch xPackageManager:${NC}"
echo "  • From terminal: ${BOLD}xpackagemanager${NC}"
echo "  • From app menu: Search for 'xPackage Manager'"
echo ""
print_info "This version works on ALL Arch-based distributions!"
print_info "No distro restrictions or LD_PRELOAD hacks required."
echo ""
