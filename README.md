# Setup

~~~
cd openvpn_cert_generator
docker build -t openvpn_cert_generator .
docker run -v ~/gits/openvpn_cert_generator/certs:/tmp/output openvpn_cert_generator
<Configure VPN>
shred /tmp/tempca/
~~~