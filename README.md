# xPackageManager — CyberXero Edition

<p align="center">
  <img src="https://github.com/user-attachments/assets/14417881-daf0-4861-9c20-034db667cea4" alt="xPackageManager Screenshot" width="800">
</p>

<p align="center">
  <strong>A modern package manager for Arch Linux — unlocked for all distributions</strong>
</p>

<p align="center">
  <a href="#installation">Install</a> •
  <a href="#features">Features</a> •
  <a href="#whats-changed">What's Changed</a> •
  <a href="#cyberxero-toolkit">Toolkit Integration</a>
</p>

---

## Overview

xPackageManager is a Qt6-based graphical package manager supporting both **pacman** (via libalpm) and **Flatpak** backends. Originally exclusive to XeroLinux, this fork removes the distribution restriction at the source level — no hacks, no workarounds, just clean code.

**Part of the [CyberXero Toolkit](https://github.com/MurderFromMars/CyberXero-Toolkit) ecosystem.**

## Features

- **Dual Backend Support** — Manage pacman and Flatpak packages from one interface
- **Modern Qt6 UI** — Native desktop experience with QML and Qt Quick
- **Rust Backend** — Safe, fast, concurrent package operations
- **System Maintenance** — Orphan detection, cache cleanup, database sync
- **Universal Compatibility** — Works on any Arch-based distribution

## Installation

### One-Liner

```bash
bash <(curl -sL https://raw.githubusercontent.com/MurderFromMars/xPackageManager/main/install.sh)
```

### Via CyberXero Toolkit

Install through the toolkit GUI under **Servicing → System Tweaks → xPackageManager**.

### Manual

```bash
git clone https://github.com/MurderFromMars/xPackageManager.git
cd xPackageManager
./install.sh
```

The installer handles everything:
- ✅ Installs build dependencies (rust, qt6-base, qt6-declarative)
- ✅ Compiles from source with the patch applied
- ✅ Installs to `/opt/xpackagemanager/`
- ✅ Creates desktop entry and polkit policy
- ✅ No root required to run — uses polkit for privileged operations

## Usage

**Terminal:**
```bash
xpackagemanager
```

**Application Menu:** Search for "xPackage Manager"

## Uninstallation

```bash
git clone https://github.com/MurderFromMars/xPackageManager.git
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

## What's Changed

This fork applies a single, clean patch — removing the distribution check from the source code.

**Original** (`crates/xpm-ui/src/main.rs`):
```rust
if !is_xerolinux_distro() {
    let warning = DistroWarning::new().expect("Failed to create warning window");
    warning.on_dismiss(move || {
        std::process::exit(0);
    });
    warning.run().expect("Failed to run warning window");
    return;
}
```

**Patched:**
```rust
// Distribution check removed — works on all Arch-based systems
```

That's it. No binary patching, no LD_PRELOAD tricks, no system file modifications. Your `/etc/os-release` and `/etc/lsb-release` stay untouched.

## Tested Distributions

| Distribution | Status |
|--------------|--------|
| Arch Linux | ✅ Works |
| EndeavourOS | ✅ Works |
| Manjaro | ✅ Works |
| Garuda Linux | ✅ Works |
| ArcoLinux | ✅ Works |
| CachyOS | ✅ Works |
| XeroLinux | ✅ Works |

Any Arch-based distribution with pacman should work.

## CyberXero Toolkit

This package is part of the **CyberXero Toolkit** — a comprehensive system management suite for Arch Linux.

**Install via Toolkit:**
1. Launch CyberXero Toolkit
2. Navigate to **Servicing** tab
3. Find **xPackageManager** under System Tweaks
4. Click **Install**

The toolkit handles dependencies, building, and installation automatically.

**Other CyberXero Projects:**
- [CyberXero Toolkit](https://github.com/MurderFromMars/CyberXero-Toolkit) — System management GUI
- [CyberXero Desktop](https://github.com/MurderFromMars/CyberXero) — Cyberpunk KDE Plasma theme

## Building from Source

```bash
# Development build
cargo run --bin xpm-ui

# Release build
cargo build --release
./target/release/xpm-ui
```

## Architecture

| Crate | Purpose |
|-------|---------|
| `xpm-core` | Core types and traits |
| `xpm-alpm` | Pacman/libalpm backend |
| `xpm-flatpak` | Flatpak backend |
| `xpm-service` | Service layer orchestrating backends |
| `xpm-ui` | Qt/QML user interface |

## FAQ

**Q: Will XeroLinux repositories work?**  
A: The code includes optional support for `xerolinux` and `chaotic-aur` repos. If they're not configured on your system, they're simply skipped.

**Q: Does this modify system files?**  
A: No. The distribution check is removed at compile time. Your system configuration stays untouched.

**Q: Is this safe?**  
A: Yes. This is a source-level patch that removes a single conditional. The rest of the codebase is unchanged.

**Q: Can I contribute?**  
A: Pull requests welcome!

## Credits

- **Original xPackageManager** — XeroLinux team
- **CyberXero Edition** — [MurderFromMars](https://github.com/MurderFromMars)
- **Built with** — Rust, Qt 6, Slint UI

## License

GPL-3.0-or-later (same as original)

---

<p align="center">
  <strong>CyberXero Edition</strong> — Part of the CyberXero ecosystem
</p>
