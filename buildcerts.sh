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
    cat /tmp/CA/keys/ca.crt >> /tmp/configs/${CLIENT}.ovpn
    echo "</ca>" >> /tmp/configs/${CLIENT}.ovpn

    echo -e $"<cert>" >> /tmp/configs/${CLIENT}.ovpn
    cat /tmp/CA/keys/ca.crt >> /tmp/configs/${CLIENT}.ovpn
    echo -e $"</cert>" >> /tmp/configs/${CLIENT}.ovpn

    echo -e $"<key>" >> /tmp/configs/${CLIENT}.ovpn
    cat /tmp/CA/keys/${CLIENT}.key
    cat /tmp/CA/keys/${CLIENT}.key >> /tmp/configs/${CLIENT}.ovpn
    echo -e $"</key>" >> /tmp/configs/${CLIENT}.ovpn

    echo -e $"<tls-auth>" >> /tmp/configs/${CLIENT}.ovpn
    cat /tmp/CA/keys/ta.key >> /tmp/configs/${CLIENT}.ovpn
    echo -e $"</tls-auth> " >> /tmp/configs/${CLIENT}.ovpn

  done


# This is the directory we mounted when we run the container
cp -rR /tmp/configs/* /tmp/output
