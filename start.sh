#!/bin/bash

mkdir -p /var/run/sshd
/usr/sbin/sshd

PORT=${PORT:-8080}
mkdir -p /www
cat > /www/index.html <<EOF
<!DOCTYPE html>
<html><head><title>Railway VPS</title></head><body>
<h1>Railway VPS</h1>
<p>User: root</p>
<p>Pass: 2010</p>
</body></html>
EOF
python3 -m http.server $PORT -d /www > /dev/null 2>&1 &

echo ""
echo "======================="
echo " RAILWAY VPS ACTIVE"
echo "======================="
echo " SSH        : ssh root@<railway-url>"
echo " User       : root"
echo " Password   : 2010"
echo " Node.js    : $(node -v)"
echo " npm        : $(npm -v)"
echo " Python     : $(python3 --version)"
echo " Workspace  : /workspace"
echo "======================="

while true; do
    sleep 3600
done
