#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <domain>"
    exit 1
fi

domain=$1
ip=$(dig +short "$domain" | head -n 1)

if [ -z "$ip" ]; then
    echo "Error: Could not resolve domain"
    exit 1
fi

echo "$domain resolved to $ip"

sudo iptables -A OUTPUT -d "$ip" -j DROP
sudo iptables -A INPUT -s "$ip" -j DROP
sudo iptables -A OUTPUT -d "$ip" -p icmp -j DROP
sudo iptables -A INPUT -s "$ip" -p icmp -j DROP

echo "Blocked traffic to and from $ip including ICMP"

echo
echo "Current iptables rules:"
sudo iptables -L -n --line-numbers | grep "$ip"
