#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

print_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

echo -e "${CYAN}${BOLD}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          xPackageManager — CyberXero Edition               ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ "$EUID" -eq 0 ]; then
    print_error "Do not run as root. The script will request sudo when needed."
    exit 1
fi

if [ ! -f /etc/arch-release ] && ! command -v pacman &> /dev/null; then
    print_error "This script is for Arch-based systems only."
    exit 1
fi

print_info "Installing dependencies..."
sudo pacman -S --needed --noconfirm rust qt6-base qt6-declarative pacman flatpak

print_info "Building xPackageManager (this may take a few minutes)..."
cargo build --release
if [ $? -ne 0 ]; then
    print_error "Build failed!"
    exit 1
fi

print_info "Installing to /opt/xpackagemanager/..."
sudo mkdir -p /opt/xpackagemanager
sudo install -Dm755 target/release/xpackagemanager /opt/xpackagemanager/xpackagemanager
sudo ln -sf /opt/xpackagemanager/xpackagemanager /usr/bin/xpackagemanager

print_info "Installing desktop entry..."
sudo tee /usr/share/applications/xpackagemanager.desktop > /dev/null << 'EOF'
[Desktop Entry]
Name=xPackage Manager
Comment=Modern package manager for Arch Linux
Exec=xpackagemanager
Icon=system-software-install
Terminal=false
Type=Application
Categories=System;PackageManager;
Keywords=package;manager;pacman;flatpak;
EOF

print_info "Installing MIME type..."
sudo tee /usr/share/mime/packages/x-alpm-package.xml > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
  <mime-type type="application/x-alpm-package">
    <comment>Arch Linux Package</comment>
    <glob pattern="*.pkg.tar.zst"/>
    <glob pattern="*.pkg.tar.xz"/>
    <glob pattern="*.pkg.tar.gz"/>
  </mime-type>
</mime-info>
EOF

print_info "Installing polkit policy..."
sudo tee /usr/share/polkit-1/actions/org.xpackagemanager.policy > /dev/null << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE policyconfig PUBLIC
 "-//freedesktop//DTD PolicyKit Policy Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/PolicyKit/1/policyconfig.dtd">
<policyconfig>
  <action id="org.xpackagemanager.pkexec">
    <description>Run xPackageManager privileged operations</description>
    <message>Authentication is required to manage packages</message>
    <defaults>
      <allow_any>auth_admin</allow_any>
      <allow_inactive>auth_admin</allow_inactive>
      <allow_active>auth_admin_keep</allow_active>
    </defaults>
    <annotate key="org.freedesktop.policykit.exec.path">/opt/xpackagemanager/xpackagemanager</annotate>
  </action>
</policyconfig>
EOF

print_info "Updating system databases..."
sudo update-desktop-database /usr/share/applications 2>/dev/null || true
sudo update-mime-database /usr/share/mime 2>/dev/null || true

echo ""
print_success "xPackageManager installed!"
echo ""
echo -e "${BOLD}Launch:${NC} xpackagemanager or from Application Menu"
echo ""
