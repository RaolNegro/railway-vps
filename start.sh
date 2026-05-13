#!/bin/bash

echo "======================="
echo " RAILWAY VPS"
echo "======================="
echo " User: root"
echo " Pass: 2010"
echo "======================="

/usr/sbin/sshd

TAILSCALE_AUTH_KEY="tskey-auth-k8JCrFbY1T11CNTRL-NiYDjq9ACs3cuZdVLbZus3Zw29Ko61jk"

echo "Installing Tailscale..."
curl -fsSL https://tailscale.com/install.sh | sh > /dev/null 2>&1
echo "Connecting to Tailscale..."
tailscale up --authkey="$TAILSCALE_AUTH_KEY" --hostname=railway-vps
TS_IP=$(tailscale ip -4 2>/dev/null)
echo "Tailscale IP: $TS_IP"

echo ""
echo "VPS is running!"
echo "SSH: ssh root@<tailscale-ip>  (password: 2010)"

while true; do
    sleep 3600
done
