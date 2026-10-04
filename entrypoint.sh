#!/bin/sh
set -e

# UUID for VLESS client auth
UUID_VLESS=${UUID_VLESS:-"7f3a9c2e-8b1d-4f6a-9e2c-1a5b8d3f7c4e"}

# WebSocket path prefix
WSPATH=${WSPATH:-"/alpha/secure"}

# Listening port (Render sets this automatically)
PORT=${PORT:-"8080"}

cat > /etc/xray/config.json << EOF
{
  "log": {
    "loglevel": "warning"
  },
  "inbounds": [
    {
      "port": $PORT,
      "listen": "0.0.0.0",
      "protocol": "vless",
      "settings": {
        "clients": [
          {
            "id": "$UUID_VLESS"
          }
        ],
        "decryption": "none"
      },
      "streamSettings": {
        "network": "ws",
        "wsSettings": {
          "path": "$WSPATH/vless"
        }
      }
    }
  ],
  "outbounds": [
    {
      "protocol": "freedom"
    }
  ]
}
EOF

echo "Starting Xray on port $PORT, VLESS path: $WSPATH/vless"
exec xray -config /etc/xray/config.json
