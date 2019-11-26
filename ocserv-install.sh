#!/bin/bash
cd ~
echo "welcome"
echo ip addr | grep -Po '(?!(inet 127.\d.\d.1))(inet \K(\d{1,3}\.){3}\d{1,3})' 

sudo apt install gnutls-bin
mkdir certificates
cd certificates
nano ca.tmpl

cat << EOF > ca.tmpl
cn = "VPN CA"
organization = "Big Corp"
serial = 1
expiration_days = 3650
ca
signing_key
cert_signing_key
crl_signing_key
EOF
certtool --generate-privkey --outfile ca-key.pem
certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem
cat << EOF > server.tmpl
cn = "your ip"
organization = "my company"
expiration_days = 3650
signing_key
encryption_key
tls_www_server
EOF