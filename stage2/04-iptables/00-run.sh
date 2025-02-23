#!/bin/bash
set -e

echo "Installing and configuring iptables..."
apt-get update
apt-get install -y iptables iptables-persistent netfilter-persistent
update-alternatives --set iptables /usr/sbin/iptables-legacy
update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy
update-alternatives --display iptables

mkdir -p /etc/iptables
touch /etc/iptables/rules.v4 /etc/iptables/rules.v6
chmod 644 /etc/iptables/rules.v4 /etc/iptables/rules.v6

systemctl enable netfilter-persistent
iptables --version
