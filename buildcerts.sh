#!/bin/bash

# Ensure the openssl.cnf file is there when it looks for it
cp /tmp/CA/openssl-1.0.0.cnf /tmp/CA/openssl.cnf
source /tmp/CA/vars
/tmp/CA/clean-all
# use --batch nopass to ensure this is unattended
/tmp/CA/build-ca --batch nopass
/tmp/CA/build-key-server --batch server nopass
/tmp/CA/build-dh
openvpn --genkey --secret /tmp/CA/keys/ta.key 

mkdir -p /tmp/configs

for CLIENT in laptop phone other;
  do
    /tmp/CA/build-key --batch $CLIENT nopass
    cp /tmp/sample.ovpn /tmp/configs/${CLIENT}.ovpn

    echo -e $"<ca>" >> /tmp/configs/${CLIENT}.ovpn
    cat /tmp/CA/keys/ca.crt | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p' >> /tmp/configs/${CLIENT}.ovpn
    echo "</ca>" >> /tmp/configs/${CLIENT}.ovpn

    echo -e $"<cert>" >> /tmp/configs/${CLIENT}.ovpn
    cat /tmp/CA/keys/${CLIENT}.crt | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p' >> /tmp/configs/${CLIENT}.ovpn
    echo -e $"</cert>" >> /tmp/configs/${CLIENT}.ovpn

    echo -e $"<key>" >> /tmp/configs/${CLIENT}.ovpn
    cat /tmp/CA/keys/${CLIENT}.key >> /tmp/configs/${CLIENT}.ovpn
    echo -e $"</key>" >> /tmp/configs/${CLIENT}.ovpn

    echo -e $"<tls-auth>" >> /tmp/configs/${CLIENT}.ovpn
    cat /tmp/CA/keys/ta.key | sed -n -e '/-----BEGIN OpenVPN Static key V1-----/,$p' >> /tmp/configs/${CLIENT}.ovpn
    echo -e $"</tls-auth>" >> /tmp/configs/${CLIENT}.ovpn


    echo "===================================="
    echo "This is the server config"

    echo "Paste to Public Server cert"
    cat /tmp/CA/keys/server.crt | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p'
   
    echo "Paste to CA Cert"
    cat /tmp/CA/keys/ca.crt | sed -n -e '/-----BEGIN CERTIFICATE-----/,$p'
 
    echo "Paste to Private Server Key"
    cat /tmp/CA/keys/server.key
    
    echo "PAste to DH PEM"
    cat /tmp/CA/keys/dh2048.pem

    echo "Paste to TLS Auth Key"
    cat /tmp/CA/keys/ta.key | sed -n -e '/-----BEGIN OpenVPN Static key V1-----/,$p'


  done


# This is the directory we mounted when we run the container
cp -rR /tmp/configs/* /tmp/output
