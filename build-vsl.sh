#!/bin/bash
set -e

# VSL build script
# Creates a minimal Debian-based live environment for VSL

DISTRO_NAME="VSL"
DISTRO_VERSION="1.0"
WORK_DIR="${WORK_DIR:-$PWD/vsl-build}"
OUTPUT_DIR="${OUTPUT_DIR:-$PWD/vsl-iso}"
ISO_NAME="vsl-live.iso"

echo "=================================================="
echo " VSL (Vishwa Sierra Linux) build starter"
echo "=================================================="

echo "[1/5] Preparing build directories..."
mkdir -p "$WORK_DIR" "$OUTPUT_DIR"
mkdir -p "$WORK_DIR/chroot" "$WORK_DIR/iso/boot/grub" "$WORK_DIR/iso/casper"

if ! command -v debootstrap >/dev/null 2>&1; then
  echo "Missing debootstrap. Install it first: sudo apt install debootstrap" >&2
  exit 1
fi

if ! command -v mksquashfs >/dev/null 2>&1; then
  echo "Missing mksquashfs. Install squashfs-tools first." >&2
  exit 1
fi

if ! command -v xorriso >/dev/null 2>&1; then
  echo "Missing xorriso. Install xorriso first." >&2
  exit 1
fi

echo "[2/5] Bootstrapping Debian base system..."
sudo debootstrap --arch amd64 --variant=minbase bookworm "$WORK_DIR/chroot" http://deb.debian.org/debian/

# Mount pseudo filesystems
sudo mount --bind /dev "$WORK_DIR/chroot/dev"
sudo mount --bind /proc "$WORK_DIR/chroot/proc"
sudo mount --bind /sys "$WORK_DIR/chroot/sys"

echo "[3/5] Installing core packages in chroot..."
sudo chroot "$WORK_DIR/chroot" /bin/bash <<'CHROOT'
set -e
apt-get update
apt-get install -y --no-install-recommends \
  systemd-sysv \
  dbus \
  sudo \
  bash \
  coreutils \
  util-linux \
  grep \
  sed \
  ca-certificates \
  network-manager \
  xorg \
  xfce4 \
  xfce4-goodies \
  lightdm \
  firefox-esr \
  vim \
  curl \
  wget \
  git \
  htop \
  fonts-noto \
  libinput-tools \
  xserver-xorg-input-libinput \
  xserver-xorg-input-evdev

locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8

echo "vsl-live" > /etc/hostname
cat >/etc/hosts <<'EOF'
127.0.0.1 localhost
127.0.1.1 vsl-live
::1 localhost ip6-localhost ip6-loopback
EOF

# Create demo user
id -u vsl >/dev/null 2>&1 || useradd -m -s /bin/bash -G sudo vsl
chpasswd <<'EOF'
vsl:vsl
EOF

# Add startup script for VSL theme
mkdir -p /etc/profile.d
cat >/etc/profile.d/vsl-welcome.sh <<'EOF'
#!/bin/bash
printf '\n==================================================\n'
printf ' Welcome to VSL (Vishwa Sierra Linux)\n'
printf ' macOS Sierra-inspired lightweight Linux desktop\n'
printf '==================================================\n\n'
EOF
chmod +x /etc/profile.d/vsl-welcome.sh
CHROOT

echo "[4/5] Preparing live boot files..."
# Copy kernel + initramfs into live ISO structure
sudo cp "$WORK_DIR/chroot/boot/vmlinuz-"* "$WORK_DIR/iso/casper/vmlinuz" || true
sudo cp "$WORK_DIR/chroot/boot/initrd.img-"* "$WORK_DIR/iso/casper/initrd.img" || true

# Build squashfs
sudo mksquashfs "$WORK_DIR/chroot" "$WORK_DIR/iso/casper/filesystem.squashfs" -comp xz

cat > "$WORK_DIR/iso/boot/grub/grub.cfg" <<EOF
set default=0
set timeout=10

menuentry "VSL (Vishwa Sierra Linux)" {
  linux /casper/vmlinuz boot=casper quiet splash
  initrd /casper/initrd.img
}
EOF

echo "[5/5] Building ISO..."
mkdir -p "$OUTPUT_DIR"
sudo xorriso -as mkisofs \
  -iso-level 3 \
  -full-iso9660-filenames \
  -volid "VSLLIVE" \
  -eltorito-boot boot/grub/i386-pc/eltorito.img \
  -no-emul-boot \
  -boot-load-size 4 \
  -boot-info-table \
  -o "$OUTPUT_DIR/$ISO_NAME" \
  "$WORK_DIR/iso"

# Unmount pseudo filesystems
sudo umount "$WORK_DIR/chroot/dev" 2>/dev/null || true
sudo umount "$WORK_DIR/chroot/proc" 2>/dev/null || true
sudo umount "$WORK_DIR/chroot/sys" 2>/dev/null || true

echo ""
echo "Build complete. ISO created at: $OUTPUT_DIR/$ISO_NAME"
echo "Suggested login: vsl / vsl"
echo ""
