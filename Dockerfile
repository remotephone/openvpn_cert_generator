FROM ubuntu:xenial

ENV EASY_RSA /tmp/CA

RUN apt update && apt install -y easy-rsa openvpn && \
     /usr/bin/make-cadir /tmp/CA

COPY ./buildcerts.sh /tmp/buildcerts.sh 

COPY ./vars /tmp/CA/vars
COPY ./sample.ovpn /tmp/sample.ovpn

RUN chmod +x /tmp/buildcerts.sh

ENTRYPOINT ["/bin/sh", "-c", "/tmp/buildcerts.sh"]
