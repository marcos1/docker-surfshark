#!/bin/sh
rm -rf ovpn_configs*
wget -O ovpn_configs.zip ${URFSHARK_CONFIG_UR}
unzip ovpn_configs.zip -d ovpn_configs
if [ -d "ovpn_configs"]
then
    cd ovpn_configs
else if [ -d "China_udp_*"]
then
    cd China_udp_*
fi
VPN_FILE=$(ls "${SURFSHARK_COUNTRY}"* | grep "${SURFSHARK_CITY}" | grep "${CONNECTION_TYPE}" | shuf | head -n 1)
echo Chose: ${VPN_FILE}
printf "${SURFSHARK_USER}\n${SURFSHARK_PASSWORD}" > vpn-auth.txt

if [ -n ${LAN_NETWORK}  ]
then
    DEFAULT_GATEWAY=$(ip -4 route list 0/0 | cut -d ' ' -f 3)
    
    splitSubnets=$(echo ${LAN_NETWORK} | tr "," "\n")
    
    for subnet in $splitSubnets
    do  
        ip route add "$subnet" via "${DEFAULT_GATEWAY}" dev eth0
        echo Adding ip route add "$subnet" via "${DEFAULT_GATEWAY}" dev eth0 for attached container web ui access
    done
    
    echo Do not forget to expose the ports for attached container web ui access
fi

if [ "${CREATE_TUN_DEVICE}" = "true" ]; then
  echo "Creating TUN device /dev/net/tun"
  mkdir -p /dev/net
  mknod /dev/net/tun c 10 200
  chmod 0666 /dev/net/tun
fi

openvpn --config $VPN_FILE --auth-user-pass vpn-auth.txt --mute-replay-warnings $OPENVPN_OPTS