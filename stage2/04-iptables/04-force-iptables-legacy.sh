#!/bin/bash
set -e

echo "Forcing iptables-legacy at boot..."

cat <<EOF > /etc/systemd/system/iptables-legacy.service
[Unit]
Description=Ensure iptables-legacy is used
Before=network-pre.target
Wants=network-pre.target
DefaultDependencies=no

[Service]
Type=oneshot
ExecStart=/usr/sbin/update-alternatives --set iptables /usr/sbin/iptables-legacy
ExecStart=/usr/sbin/update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl enable iptables-legacy.service
