FROM alpine:latest

# set version label
ARG BUILD_DATE=2022/7/4
ARG VERSION=v2.01
LABEL build_version="  version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="marcos1"

ENV SURFSHARK_USER=
ENV SURFSHARK_PASSWORD=
ENV SURFSHARK_COUNTRY=
ENV SURFSHARK_CITY=
ENV OPENVPN_OPTS=
ENV CONNECTION_TYPE=tcp
ENV LAN_NETWORK=0.0.0.0/0
ENV CREATE_TUN_DEVICE=false
ENV SURFSHARK_CONFIG_URL=https://my.surfshark.com/vpn/api/v1/server/configurations

RUN \
    apk add \
    --update --no-cache --upgrade --virtual=build-dependencies \
        bash \
        openvpn \
        wget \
        unzip \
        coreutils \
        curl

WORKDIR /vpn

COPY startup.sh .

RUN \
    chmod +x ./startup.sh

HEALTHCHECK --interval=60s --timeout=10s --start-period=30s CMD curl -L 'https://ipinfo.io'
ENTRYPOINT [ "./startup.sh" ]
