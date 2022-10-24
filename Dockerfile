FROM alpine:3.13

ENV OCSERV_VERSION 1.1.2
ENV MAXMIND_VERSION=1.7.1
ENV CA_CN SAMPLE CA
ENV CA_ORG Big Corp
ENV SRV_CN SAMPLE server
ENV SRV_ORG MyCompany
RUN set -ex && \
    apk update && \
    apk add --no-cache --virtual .build-dependencies \
    readline-dev \
    libnl3-dev \
    xz \
    openssl \
    make \
    gcc \
    autoconf \
    musl-dev \
    wget \
    linux-headers \
    gnutls-dev \
    linux-pam-dev \
    libseccomp-dev \
    lz4-dev \
    libev-dev \
    protobuf-c-dev \
    krb5-dev \
    gnutls-utils \
    oath-toolkit-dev \
    && wget https://github.com/maxmind/libmaxminddb/releases/download/${MAXMIND_VERSION}/libmaxminddb-${MAXMIND_VERSION}.tar.gz \
    && tar xf libmaxminddb-${MAXMIND_VERSION}.tar.gz \
    && cd libmaxminddb-${MAXMIND_VERSION} \
    && ./configure \
    && make \
    && make check \
    && make install \
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
    && apk del .build-dependencies \
    && apk add --no-cache gnutls linux-pam krb5-libs libtasn1 oath-toolkit-liboath nettle libev protobuf-c musl lz4-libs libseccomp readline libnl3 iptables \
    && rm -rf /var/cache/apk/*
WORKDIR /etc/ocserv
COPY ocserv.conf /etc/ocserv/ocserv.conf
COPY script/ocadduser  /usr/local/bin/ocadduser
RUN chmod +x /usr/local/bin/ocadduser
COPY script/ocdeluser  /usr/local/bin/ocdeluser
RUN chmod +x /usr/local/bin/ocdeluser
COPY script/oclukuser  /usr/local/bin/oclukuser
RUN chmod +x /usr/local/bin/oclukuser
COPY script/oculkuser  /usr/local/bin/oculkuser
RUN chmod +x /usr/local/bin/oculkuser
COPY script/oclsusers  /usr/local/bin/oclsusers
RUN chmod +x /usr/local/bin/oclsusers
COPY entrypoint.sh /entrypoint.sh
COPY sysctl.conf /etc/ocserv/sysctl.conf
EXPOSE 443/tcp
EXPOSE 443/udp
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
