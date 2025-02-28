#!/bin/bash
# Install IP routing configuration script and service

set -x  # Enable debugging

LOG_FILE="${ROOTFS_DIR}/var/log/iptables-setup.log"
echo "Starting iptables setup" | tee -a "$LOG_FILE"

# Install firewall config script and service
install -m 755 files/raspap-routing.sh "${ROOTFS_DIR}/usr/local/bin/raspap-routing.sh"
install -m 644 files/routing.service "${ROOTFS_DIR}/etc/systemd/system/routing.service"

# Verify installation
ls -l "${ROOTFS_DIR}/usr/local/bin/" | tee -a "$LOG_FILE"
ls -l "${ROOTFS_DIR}/etc/systemd/system/" | tee -a "$LOG_FILE"

# Enable IP routing on first boot
on_chroot << EOF
systemctl enable routing.service 2>&1 | tee -a "$LOG_FILE"
EOF

echo "Finished iptables setup" | tee -a "$LOG_FILE"

