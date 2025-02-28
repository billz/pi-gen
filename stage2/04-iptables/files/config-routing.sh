#!/bin/bash
echo "Detecting firewall backend..."

if command -v nft &> /dev/null; then
    echo "Using nftables"

    cat <<EOF | sudo tee /etc/nftables.conf
table inet filter {
    chain input {
        type filter hook input priority 0; policy accept;
    }
    chain forward {
        type filter hook forward priority 0; policy accept;
    }
    chain output {
        type filter hook output priority 0; policy accept;
    }
}
table ip nat {
    chain postrouting {
        type nat hook postrouting priority 100;
        ip saddr 192.168.50.0/24 masquerade
    }
}
EOF

    sudo systemctl enable nftables
    sudo systemctl restart nftables

elif command -v iptables &> /dev/null; then
    echo "Using iptables"

    # Enable NAT for outgoing traffic
    sudo iptables -t nat -A POSTROUTING -s 192.168.50.0/24 ! -d 192.168.50.0/24 -j MASQUERADE

    # Persist rules
    sudo iptables-save | sudo tee /etc/iptables/rules.v4 > /dev/null

    sudo systemctl enable netfilter-persistent
    sudo systemctl restart netfilter-persistent

else
    echo "No firewall backend found! Network NAT may not work correctly."
fi

# Disable this service after first boot
sudo systemctl disable routing.service

