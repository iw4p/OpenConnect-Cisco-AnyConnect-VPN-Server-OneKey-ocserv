FROM ubuntu:24.04

ENV OCSERV_VERSION 1.3.0
ENV CA_CN SAMPLE CA
ENV CA_ORG Big Corp
ENV SRV_CN SAMPLE server
ENV SRV_ORG MyCompany
RUN set -ex \
    && apt-get update \
    && apt-get install -y \
      build-essential pkg-config \
      libgnutls28-dev libev-dev \
      libpam0g-dev liblz4-dev libseccomp-dev \
      libreadline-dev libnl-route-3-dev libkrb5-dev libradcli-dev \
      libcurl4-gnutls-dev libcjose-dev libjansson-dev liboath-dev \
      libprotobuf-c-dev libtalloc-dev node-undici protobuf-c-compiler \
      gperf iperf3 lcov libuid-wrapper libpam-wrapper libnss-wrapper \
      libsocket-wrapper gss-ntlmssp haproxy iputils-ping freeradius \
      gawk gnutls-bin iproute2 yajl-tools tcpdump \
      ronn \
      wget tar ipcalc-ng libjemalloc2 iptables \
    && wget ftp://ftp.infradead.org/pub/ocserv/ocserv-$OCSERV_VERSION.tar.xz \
    && mkdir -p /etc/ocserv \
    && tar xf ocserv-$OCSERV_VERSION.tar.xz \
    && rm ocserv-$OCSERV_VERSION.tar.xz \
    && cd ocserv-$OCSERV_VERSION \
    && ./configure \
    && make \
    && make install \
    && cd .. \
    && rm -rf ocserv-$OCSERV_VERSION \
    && mkdir -p /etc/ocserv/certs \
    && cd /etc/ocserv/certs \
    && certtool --generate-privkey --outfile ca-key.pem \
    && touch ca.tmpl \
    && echo "cn = $CA_CN" >> ca.tmpl \
    && echo "organization = $CA_ORG" >> ca.tmpl \
    && echo "serial = 1" >> ca.tmpl \
    && echo "expiration_days = -1" >> ca.tmpl \
    && echo "ca" >> ca.tmpl \
    && echo "signing_key" >> ca.tmpl \
    && echo "cert_signing_key" >> ca.tmpl \
    && echo "crl_signing_key" >> ca.tmpl \
    && certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem \
    && certtool --generate-privkey --outfile server-key.pem \
    && touch server.tmpl \
    && echo "cn = $SRV_CN" >> server.tmpl \
    && echo "organization = $SRV_ORG" >> server.tmpl \
    && echo "expiration_days = -1" >> server.tmpl \
    && echo "signing_key" >> server.tmpl \
    && echo "encryption_key" >> server.tmpl \
    && echo "tls_www_server" >> server.tmpl \
    && certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem \
    && touch /etc/ocserv/ocpasswd
WORKDIR /etc/ocserv
COPY ocserv.conf /etc/ocserv/ocserv.conf
COPY entrypoint.sh /entrypoint.sh
EXPOSE 443/tcp
EXPOSE 443/udp
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
