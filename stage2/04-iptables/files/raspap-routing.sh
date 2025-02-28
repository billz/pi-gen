#!/bin/bash
echo "Detecting firewall backend..."

if command -v nft &> /dev/null; then
    echo "Using nftables"

    cat <<EOF | sudo tee /etc/nftables.conf
table inet ap {
	chain routethrough {
		type nat hook postrouting priority srcnat; policy accept;
		oifname "eth0" masquerade
	}

	chain fward {
		type filter hook forward priority filter; policy accept;
		iifname "eth0" oifname "wlan0" ct state established,related accept
		iifname "wlan0" oifname "eth0" accept
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

