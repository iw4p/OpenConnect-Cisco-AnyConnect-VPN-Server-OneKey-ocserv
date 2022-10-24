#!/bin/sh
set -e

touch -a /data/ocpasswd
iptables -t nat -A POSTROUTING -j MASQUERADE
cp /etc/ocserv/sysctl.conf /etc/sysctl.conf
sysctl -p
exec "$@"
