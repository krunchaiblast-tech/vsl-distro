# VSL (Vishwa Sierra Linux)

VSL is a lightweight Linux desktop concept built around a macOS Sierra-inspired experience, targeting low-resource laptops and desktops while staying under 800MB RAM usage in normal use.

This repository is the starting point for a custom Linux distro project with:
- a premium Sierra-style desktop
- a translucent LCD glass dock
- trackpad gesture support
- camera-based motion gesture controls
- a minimal Debian-based build path

## Project goals
- Max RAM usage: 800MB in normal workflow
- Theme: Sierra-inspired UI with polished glass panels
- Dock: LCD transparency effect for application dock and app icons
- Gestures: Mac-style trackpad interactions
- Accessibility: optional camera motion controls
- Aim: create a premium, memorable Linux desktop experience

## Design direction
The visual style is inspired by the provided reference image showing a warm mountain wallpaper, clean top bar, minimal dock, and elegant UI spacing.

The project uses a macOS Sierra-like aesthetic without copying Apple proprietary assets. It is designed as a custom Linux distro identity.

## Features
- LCD transparent glass app dock
- Sierra-like wallpaper and color palette
- Lightweight base system
- Minimal Debian/Ubuntu package set
- VSL Settings utility for system controls
- Trackpad and gesture tuning
- Camera gesture configuration panel
- VM and ISO build workflow

## Repository contents
- `build-vsl.sh` – build script to create a lightweight live ISO base
- `vsl-settings.py` – settings app for trackpad, dock, and camera controls
- `vsl-theme/xfce4-panel.css` – glass dock styling with LCD transparency
- `vsl-theme/xfce4-desktop.css` – desktop and window visual styling
- `scripts/install-vsl-theme.sh` – theme installer for XFCE-based system builds

## Build quickstart

### Requirements
- Debian/Ubuntu host
- root privileges
- `debootstrap`, `squashfs-tools`, `xorriso`, `grub-pc-bin`

### Install dependencies
```bash
sudo apt update
sudo apt install -y debootstrap squashfs-tools xorriso grub-pc-bin
```

### Run build
```bash
chmod +x build-vsl.sh
sudo ./build-vsl.sh
```

This creates a minimal ISO build scaffold for a VSL-based system.

## Theme notes
The app dock uses an LCD transparency effect by layering translucent backgrounds with soft blur-like color treatment and slightly tinted panels. The effect is designed to feel premium and modern without requiring heavy desktop resources.

## Trackpad and camera features
Planned system features include:
- 2-finger scroll
- 3-finger swipe navigation
- pinch to zoom
- natural scrolling
- optional camera-based finger tracking
- gesture calibration settings

## Security and privacy
Camera-based gesture control is optional and disabled by default. The system should request explicit permission before enabling any motion tracking features.

## Roadmap
- Build a minimal Debian live base
- Add Sierra-inspired XFCE panel UI
- Implement dock transparency and effect tuning
- Add trackpad gesture settings
- Add camera gesture detection framework
- Validate memory usage under 800MB
- Package into a bootable ISO

## License
MIT

## Status
This repository is the initial base project. It is intended to grow into a bootable VSL distro build system and premium Linux desktop environment.
