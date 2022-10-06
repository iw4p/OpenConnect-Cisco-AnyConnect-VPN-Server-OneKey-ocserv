# FROM alpine:3.14
# ENV OCSERV_VERSION 1.1.2
# RUN set -ex \
#     && apk add --virtual .build-dependencies \
#     readline-dev \
#     libnl3-dev \
#     xz \
#     openssl \
#     make \
#     gcc \
#     autoconf \
#     musl-dev \
#     wget \
#     linux-headers \
#     gnutls-dev \
#     linux-pam-dev \
#     libseccomp-dev \
#     lz4-dev \
#     libev-dev \
#     protobuf-c-dev \
#     krb5-dev \
#     gnutls-utils \
#     oath-toolkit-dev \
#     libmaxminddb-dev \
#     iptables \
#     && mkdir certificates \
#     && cd certificates \
#     && echo -e '\
#     cn = "VPN CA"\n\
#     organization = "Big Corp"\n\
#     serial = 1\n\
#     expiration_days = 3650\n\
#     ca\n\
#     signing_key\n\
#     cert_signing_key\n\
#     crl_signing_key\
#     ' > ca.tmpl \
#     && certtool --generate-privkey --outfile ca-key.pem \
#     && certtool --generate-self-signed --load-privkey ca-key.pem --template ca.tmpl --outfile ca-cert.pem \
#     && echo -e '\
#     cn=$ip\n\
#     organization = "my company"\n\
#     expiration_days = 3650\n\
#     signing_key\n\
#     encryption_key\n\
#     tls_www_server\
#     ' > server.tmpl \
#     && certtool --generate-privkey --outfile server-key.pem \
#     && certtool --generate-certificate --load-privkey server-key.pem --load-ca-certificate ca-cert.pem --load-ca-privkey ca-key.pem --template server.tmpl --outfile server-cert.pem \
# 	&& curl -LO ftp://ftp.infradead.org/pub/ocserv/ocserv-$OCSERV_VERSION.tar.xz \
# 	&& mkdir -p /usr/src/ocserv \
# 	&& tar -xJf ocserv-$OCSERV_VERSION.tar.xz -C /usr/src/ocserv --strip-components=1 \
# 	&& rm ocserv-$OCSERV_VERSION.tar.xz* \
# 	&& cd /usr/src/ocserv \
# 	&& ./configure \
# 	&& make \
# 	&& make install \
# 	&& mkdir -p /etc/ocserv \
# 	&& cp /usr/src/ocserv/doc/sample.config /etc/ocserv/ocserv.conf \
# 	&& cd / \
# 	&& rm -fr /usr/src/ocserv \
# 	&& rm -rf /var/cache/apk/* \
#     && sed -i -e 's@auth = "@#auth = "@g' /etc/ocserv/ocserv.conf \
#     && sed -i -e 's@auth = "pam@auth = "#auth = "pam"@g' /etc/ocserv/ocserv.conf \
#     && sed -i -e 's@try-mtu-discovery = @try-mtu-discovery = true@g' /etc/ocserv/ocserv.conf \
#     && sed -i -e 's@dns = @#dns = @g' /etc/ocserv/ocserv.conf \ 
#     && sed -i -e 's@# multiple servers.@dns = 8.8.8.8@g' /etc/ocserv/ocserv.conf \ 
#     && sed -i -e 's@route =@#route =@g' /etc/ocserv/ocserv.conf \ 
#     && sed -i -e 's@no-route =@#no-route =@g' /etc/ocserv/ocserv.conf \ 
#     && sed -i -e 's@cisco-client-compat@cisco-client-compat = true@g' /etc/ocserv/ocserv.conf \ 
#     && sed -i -e 's@##auth = "#auth = "pam""@auth = "plain[passwd=/etc/ocserv/ocpasswd]"@g' /etc/ocserv/ocserv.conf \
#     && sed -i -e 's@server-cert = /etc/ssl/certs/ssl-cert-snakeoil.pem@server-cert = /etc/ocserv/server-cert.pem@g' /etc/ocserv/ocserv.conf \
#     && sed -i -e 's@server-key = /etc/ssl/private/ssl-cert-snakeoil.key@server-key = /etc/ocserv/server-key.pem@g' /etc/ocserv/ocserv.conf \
#     && ocpasswd -c /etc/ocserv/ocpasswd testuser
#     # && iptables -t nat -A POSTROUTING -j MASQUERADE \
#     # && sed -i -e 's@#net.ipv4.ip_forward=@net.ipv4.ip_forward=1@g' /etc/sysctl.conf \
#     # && sysctl -p /etc/sysctl.conf \
#     # && cp ~/certificates/server-key.pem /etc/ocserv/ \
#     # && cp ~/certificates/server-cert.pem /etc/ocserv/ \
#     # && service ocserv stop \
#     # && service ocserv start
# # COPY entrypoint.sh /entrypoint.sh
# # EXPOSE 443/tcp
# # EXPOSE 443/udp
# # ENTRYPOINT ["sh", "/entrypoint.sh"]
# # CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
# WORKDIR /etc/ocserv

# COPY ocserv.conf /etc/ocserv/ocserv.conf
# COPY entrypoint.sh /entrypoint.sh

# EXPOSE 443/tcp
# EXPOSE 443/udp

# ENTRYPOINT ["sh", "/entrypoint.sh"]
# CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
FROM alpine:3.13

ENV OCSERV_VERSION 1.1.2
ENV CA_CN VPN CA
ENV CA_ORG Big Corp
ENV SRV_CN VPN server
ENV SRV_ORG MyCompany

RUN set -ex \
    && apk add --no-cache --virtual .build-dependencies \
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
    libmaxminddb-dev \
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
    && touch /etc/ocserv/ocpasswd \
    && apk del .build-dependencies \
    && apk add --no-cache gnutls linux-pam krb5-libs libtasn1 oath-toolkit-liboath nettle libev protobuf-c musl lz4-libs libseccomp readline libnl3 iptables \
    && rm -rf /var/cache/apk/*

WORKDIR /etc/ocserv

COPY ocserv.conf /etc/ocserv/ocserv.conf
COPY entrypoint.sh /entrypoint.sh

EXPOSE 443/tcp
EXPOSE 443/udp

ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD ["ocserv", "-c", "/etc/ocserv/ocserv.conf", "-f"]
