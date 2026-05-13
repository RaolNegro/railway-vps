#!/bin/bash

echo "======================="
echo " RAILWAY VPS"
echo "======================="
echo " User: root"
echo " Pass: 2010"
echo "======================="

/usr/sbin/sshd
echo "SSH OK"

TAILSCALE_AUTH_KEY="tskey-auth-k8JCrFbY1T11CNTRL-NiYDjq9ACs3cuZdVLbZus3Zw29Ko61jk"

mkdir -p /var/lib/tailscale /var/run/tailscale /var/cache/tailscale

echo "Starting tailscaled..."
tailscaled --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock 2>&1 &
sleep 4

if ! pgrep -x tailscaled > /dev/null; then
    echo "tailscaled failed, retrying with userspace tun..."
    tailscaled --tun=userspace-networking --state=/var/lib/tailscale/tailscaled.state --socket=/var/run/tailscale/tailscaled.sock 2>&1 &
    sleep 4
fi

if pgrep -x tailscaled > /dev/null; then
    echo "tailscaled running, connecting..."
    tailscale --socket=/var/run/tailscale/tailscaled.sock up --authkey="$TAILSCALE_AUTH_KEY" --hostname=railway-vps --accept-dns=false
    TS_IP=$(tailscale --socket=/var/run/tailscale/tailscaled.sock ip -4)
    echo "Tailscale IP: $TS_IP"
else
    echo "tailscaled FAILED to start"
    TS_IP="NOT CONNECTED"
fi

PORT=${PORT:-8080}
mkdir -p /www
cat > /www/index.html <<EOF
<!DOCTYPE html>
<html><head><title>Railway VPS</title></head><body>
<h1>Railway VPS</h1>
<p>User: root</p>
<p>Pass: 2010</p>
<p>Tailscale IP: $TS_IP</p>
<p>SSH: ssh root@$TS_IP</p>
</body></html>
EOF

python3 -m http.server $PORT -d /www > /dev/null 2>&1 &

echo "======================="
echo " VPS RUNNING"
echo " Tailscale IP: $TS_IP"
echo " SSH: ssh root@$TS_IP  (pass: 2010)"
echo "======================="

while true; do sleep 3600; done
