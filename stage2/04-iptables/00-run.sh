#!/bin/bash
# Install IP routing configuration script and service

install -m 755 files/config-routing.sh "${ROOTFS_DIR}/usr/local/bin/config-routing.sh"
install -m 644 files/routing.service "${ROOTFS_DIR}/etc/systemd/system/routing.service"

# Enable IP routing on first boot
on_chroot << EOF
systemctl enable routing.service
EOF

