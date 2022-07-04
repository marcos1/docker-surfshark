FROM alpine:latest

# set version label
ARG BUILD_DATE=2022/7/4
ARG VERSION=v1
LABEL build_version="  version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="marcos1"

ENV SURFSHARK_USER=
ENV SURFSHARK_PASSWORD=
ENV SURFSHARK_COUNTRY=hk
ENV SURFSHARK_CITY=
ENV OPENVPN_OPTS=
ENV CONNECTION_TYPE=tcp
ENV LAN_NETWORK=0.0.0.0/0
ENV CREATE_TUN_DEVICE=false
ENV SURFSHARK_CONFIG_URL=https://my.surfshark.com/vpn/api/v1/server/configurations

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD curl -L 'https://ipinfo.io'

COPY startup.sh .

RUN \
    apk add \
    --update --no-cache --upgrade --virtual=build-dependencies \
        openvpn \
        wget \
        unzip \
        coreutils \
        curl && \
        chmod +x ./startup.sh && \
        echo "**** cleanup ****" && \
        apk del --purge \
            build-dependencies && \
        rm -rf \
            /root/.cache \
            /tmp/*

ENTRYPOINT [ "./startup.sh" ]