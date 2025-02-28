#!/bin/bash
# Install IP routing configuration script and service

set -x  # Enable debugging

echo "Starting IP routing setup"

# Install routing config script and service
install -m 755 files/raspap-routing.sh "${ROOTFS_DIR}/usr/local/bin/raspap-routing.sh"
install -m 644 files/routing.service "${ROOTFS_DIR}/etc/systemd/system/routing.service"

# Verify installation
ls -l "${ROOTFS_DIR}/usr/local/bin/"
ls -l "${ROOTFS_DIR}/etc/systemd/system/"

# Enable IP routing on first boot
on_chroot << EOF
systemctl enable routing.service
EOF

echo "Finished IP routing setup"
