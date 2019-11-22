# OpenVPN Cert Generator

I got tired of manually creating certificates and forgetting which one went where in my configs so I automated it.

This uses an Ubuntu container and Easy-RSA v2 to generate keys and copies the values into an OpenVPN config file you can run with certificates in line. Treat these files as highly sensitive, of course

## Setup

First clone the repo and get in the directory to bhuld the container. 

1. Edit the vars file. The key length is set to 1024 for quick testing. You'll want to use 2048 or above.
2. Edit the buildcerts.sh file. I configured this to generate 3 configs (laptop, phone, other) but you can add or remove items at will
3. Build and run the container. You'll mount a volume and that's where the configs will show up.
4. Clean up after yourself. These configs give anyone with them access to your VPN. 

~~~
mkdir /tmp/tempca
cd openvpn_cert_generator
docker build -t openvpn_cert_generator .
docker run -v /tmp/tempca:/tmp/output openvpn_cert_generator
<Configure VPN>
shred /tmp/tempca/
~~~