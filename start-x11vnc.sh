#!/bin/sh
set -e

# Wrapper to create a VNC password file and exec x11vnc with -rfbauth
# Reads VNC_PASSWORD (default: 'password')

PASS=${VNC_PASSWORD:-password}
PASSDIR=/home/pwuser/.vnc
PASSFILE="$PASSDIR/passwd"

mkdir -p "$PASSDIR"

# Create password file by passing the password as an argument to x11vnc
x11vnc -storepasswd "$PASS" "$PASSFILE" >/dev/null 2>&1

chmod 600 "$PASSFILE"
chown pwuser:pwuser "$PASSFILE" >/dev/null 2>&1 || true

# Exec so supervisord tracks the real x11vnc process and signals are delivered correctly.
exec x11vnc -display :1 -rfbport 5900 -rfbauth "$PASSFILE" -shared -forever -listen 0.0.0.0 -verbose
