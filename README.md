# xPackageManager - Universal Arch Edition

A modern package manager for Arch Linux supporting pacman (via libalpm) and Flatpak backends.

**🎉 Works on ALL Arch-based distributions! 🎉**
Part of the CyberXero jailbreak

![xPackageManager Screenshot](https://github.com/user-attachments/assets/14417881-daf0-4861-9c20-034db667cea4)

## Features

- **Dual Backend Support**: Manage both pacman packages and Flatpak applications from a single interface
- **Modern Qt 6 UI**: Built with QML and Qt Quick Controls 2 for a native desktop experience
- **Rust Backend**: Safe, fast, and concurrent package management operations
- **System Maintenance**: Orphan detection, cache cleanup, and database synchronization
- **Universal Compatibility**: Works on any Arch-based distribution (Arch, Manjaro, EndeavourOS, Garuda, etc.)

## One-Line Installation

```bash
bash <(curl -sL https://raw.githubusercontent.com/MurderFromMars/xPackageManager/main/install.sh)
```

Or clone and install:

```bash
git clone https://github.com/YOUR_USERNAME/xPackageManager.git
cd xPackageManager
./install.sh
```

## What You Get

After installation, you can launch xPackageManager:

- **From terminal**: `xpackagemanager`
- **From app menu**: Search for "xPackage Manager"

The installer will:
1. ✅ Check and install dependencies automatically
2. ✅ Build the project from source
3. ✅ Install to `/opt/xpackagemanager/`
4. ✅ Create desktop integration
5. ✅ No root required to run (uses polkit for privileged operations)

## Requirements

The install script will automatically install these if missing:

- `rust` - Rust compiler and cargo
- `qt6-base` - Qt 6 base libraries
- `qt6-declarative` - Qt Quick/QML support
- `pacman` - Already installed on Arch
- `flatpak` - Flatpak support

## Uninstallation

```bash
cd xPackageManager
./uninstall.sh
```

Or manually:

```bash
sudo rm -f /usr/bin/xpackagemanager
sudo rm -rf /opt/xpackagemanager
sudo rm -f /usr/share/applications/xpackagemanager.desktop
sudo rm -f /usr/share/mime/packages/x-alpm-package.xml
sudo rm -f /usr/share/polkit-1/actions/org.xpackagemanager.policy
```

## What Changed from Original?

This fork removes the XeroLinux distribution check from the source code.

**Original code** (`crates/xpm-ui/src/main.rs:844`):
```rust
// Check if running on XeroLinux
if !is_xerolinux_distro() {
    let warning = DistroWarning::new().expect("Failed to create warning window");
    warning.on_dismiss(move || {
        std::process::exit(0);
    });
    warning.run().expect("Failed to run warning window");
    return;
}
```

**Patched code**:
```rust
// Distro check removed - works on all Arch-based distributions
```

That's it! Simple, clean, and effective. The distribution check is completely removed at the source level.

## Building from Source

```bash
# Development
cargo run --bin xpm-ui

# Release build
cargo build --release
./target/release/xpm-ui
```

## Tested Distributions

✅ Arch Linux
✅ Manjaro
✅ EndeavourOS  
✅ Garuda Linux
✅ ArcoLinux
✅ XeroLinux
✅ Any Arch-based distribution with pacman

## FAQ

**Q: Will XeroLinux-specific repositories work?**
A: The code includes optional support for the `xerolinux` and `chaotic-aur` repositories. If these repos aren't on your system, they're simply skipped.

**Q: Do I need to modify system files?**
A: No! The distribution check has been removed from the source code. Your `/etc/os-release` stays untouched.

**Q: Is this safe?**
A: Yes. This is a source-level patch that removes a single `if` statement. No binary patching, no LD_PRELOAD tricks, just clean code.

**Q: Can I contribute?**
A: Absolutely! Pull requests welcome.

## Architecture

The project is organized into several crates:

- **xpm-core**: Core types and traits
- **xpm-alpm**: Pacman/libalpm backend
- **xpm-flatpak**: Flatpak backend
- **xpm-service**: Service layer orchestrating backends
- **xpm-ui**: Qt/QML user interface

For detailed architecture information, see `README.md.original`.

## Credits

- **Original xPackageManager**: XeroLinux team
- **Universal Arch Edition**: Community fork for all Arch-based distributions
- **Built with**: Rust, Qt 6, Slint UI framework

## License

GPL-3.0-or-later (same as original)

## Support

- **Issues with this fork**: Open an issue on this repository
- **General xPackageManager questions**: Refer to original XeroLinux documentation

---

**Note**: This is an independent community fork focused on removing distribution restrictions. For the official XeroLinux version, visit their official repositories.
