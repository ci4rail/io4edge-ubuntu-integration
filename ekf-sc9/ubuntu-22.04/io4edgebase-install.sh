#!/bin/bash

set -e
set -x

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt -y --no-install-recommends install \
    isc-dhcp-server network-manager avahi-daemon avahi-utils

HOST_ARCH=amd64
IO4EDGE_CLIENT_GO_VERSION="v1.8.0"

wget https://github.com/ci4rail/io4edge-client-go/releases/download/${IO4EDGE_CLIENT_GO_VERSION}/io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz && \
tar -C /usr/local/bin -xvf io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz io4edge-cli && \
rm io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz

# wget https://github.com/ci4rail/io4edge-client-go/releases/download/${IO4EDGE_CLIENT_GO_VERSION}/binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz && \
# tar -C /usr/local/bin -xvf binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz binaryIoTypeA_blinky && \
# rm binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz


# USB io4edge devices udev rules

echo 'ACTION=="add", ATTRS{interface}=="TinyUSB Network", PROGRAM="/usr/bin/usb_io4edge_interface_name.sh %k", NAME="%c"' > /etc/udev/rules.d/99-usb-io4edge.rules

cat <<EOF > /usr/bin/usb_io4edge_interface_name.sh 
#!/bin/sh

USB_PATH=\$(readlink /sys/class/net/\$1)

USB_PORT=\$(echo \$USB_PATH | awk -F/ '{print\$(NF-3)}')

case \$USB_PORT in

  3-7)
    echo "io4e-cpci1"
    ;;
  3-7.1)
    echo "io4e-cpci1a"
    ;;
  3-7.2)
    echo "io4e-cpci1b"
    ;;
  3-6)
    echo "io4e-cpci2"
    ;;
  3-6.1)
    echo "io4e-cpci2a"
    ;;
  3-6.2)
    echo "io4e-cpci2b"
    ;;
  3-5)
    echo "io4e-cpci3"
    ;;
  3-5.1)
    echo "io4e-cpci3a"
    ;;
  3-5.2)
    echo "io4e-cpci3b"
    ;;  
  3-4)
    echo "io4e-cpci4"
    ;;
  3-4.1)
    echo "io4e-cpci4a"
    ;;
  3-4.2)
    echo "io4e-cpci4b"
    ;;  
  3-3)
    echo "io4e-cpci5"
    ;;
  3-3.1)
    echo "io4e-cpci5a"
    ;;
  3-3.2)
    echo "io4e-cpci5b"
    ;;

  *)
    echo "unknown"
    ;;

esac
EOF
chmod +x /usr/bin/usb_io4edge_interface_name.sh

cat <<EOF > /etc/netplan/10-io4edge.yaml
network:
  version: 2
  renderer: NetworkManager
  ethernets:
    io4e-cpci1:
      dhcp4: false
      addresses: [192.168.201.10/24]
    io4e-cpci1a:
      dhcp4: false
      addresses: [192.168.202.10/24]
    io4e-cpci1b:
      dhcp4: false
      addresses: [192.168.203.10/24]
    io4e-cpci2:
      dhcp4: false
      addresses: [192.168.204.10/24]
    io4e-cpci2a:
      dhcp4: false
      addresses: [192.168.205.10/24]
    io4e-cpci2b:
      dhcp4: false
      addresses: [192.168.206.10/24]
    io4e-cpci3:
      dhcp4: false
      addresses: [192.168.207.10/24]
    io4e-cpci3a:
      dhcp4: false
      addresses: [192.168.208.10/24]
    io4e-cpci3b:
      dhcp4: false
      addresses: [192.168.209.10/24]
    io4e-cpci4:
      dhcp4: false
      addresses: [192.168.210.10/24]
    io4e-cpci4a:
      dhcp4: false
      addresses: [192.168.211.10/24]
    io4e-cpci4b:
      dhcp4: false
      addresses: [192.168.212.10/24]
    io4e-cpci5:
      dhcp4: false
      addresses: [192.168.213.10/24]
    io4e-cpci5a:
      dhcp4: false
      addresses: [192.168.214.10/24]
    io4e-cpci5b:
      dhcp4: false
      addresses: [192.168.215.10/24]
EOF
chmod 600 /etc/netplan/10-io4edge.yaml

cat <<EOF > /etc/dhcp/dhcpd.conf
ddns-update-style none;

# option definitions common to all supported networks... (not relevant for this snippet)
option domain-name "example.org";
option domain-name-servers 8.8.8.8;

default-lease-time 600;
max-lease-time 7200;

subnet 192.168.201.0 netmask 255.255.255.0 {
    range 192.168.201.1 192.168.201.1;
}
subnet 192.168.202.0 netmask 255.255.255.0 {
    range 192.168.202.1 192.168.202.1;
}
subnet 192.168.203.0 netmask 255.255.255.0 {
    range 192.168.203.1 192.168.203.1;
}
subnet 192.168.204.0 netmask 255.255.255.0 {
    range 192.168.204.1 192.168.204.1;
}
subnet 192.168.205.0 netmask 255.255.255.0 {
    range 192.168.205.1 192.168.205.1;
}
subnet 192.168.206.0 netmask 255.255.255.0 {
    range 192.168.206.1 192.168.206.1;
}
subnet 192.168.207.0 netmask 255.255.255.0 {
    range 192.168.207.1 192.168.207.1;
}
subnet 192.168.208.0 netmask 255.255.255.0 {
    range 192.168.208.1 192.168.208.1;
}
subnet 192.168.209.0 netmask 255.255.255.0 {
    range 192.168.209.1 192.168.209.1;
}
subnet 192.168.210.0 netmask 255.255.255.0 {
    range 192.168.210.1 192.168.210.1;
}
subnet 192.168.211.0 netmask 255.255.255.0 {
    range 192.168.211.1 192.168.211.1;
}
subnet 192.168.212.0 netmask 255.255.255.0 {
    range 192.168.212.1 192.168.212.1;
}
subnet 192.168.213.0 netmask 255.255.255.0 {
    range 192.168.213.1 192.168.213.1;
}
subnet 192.168.214.0 netmask 255.255.255.0 {
    range 192.168.214.1 192.168.214.1;
}
subnet 192.168.215.0 netmask 255.255.255.0 {
    range 192.168.215.1 192.168.215.1;
}

EOF

cat <<EOF > /etc/default/isc-dhcp-server
INTERFACESv4="io4e-cpci1 io4e-cpci1a io4e-cpci1b io4e-cpci2 io4e-cpci2a io4e-cpci2b io4e-cpci3 io4e-cpci3a io4e-cpci3b io4e-cpci4 io4e-cpci4a io4e-cpci4b io4e-cpci5 io4e-cpci5a io4e-cpci5b io4e-cpci8 io4e-cpci8a io4e-cpci8b "
EOF

cat <<EOF > /etc/NetworkManager/dispatcher.d/10-dhcpd-restart
#!/bin/bash
#
# This script restarts the DHDCP daemon whenever a network interface
# listed in /etc/default/dhcp-server comes up.
# This is needed to provide USB attached
# io4edge devices with an IP address whenever they are restarted.
#
#

interface=\$1 status=\$2

echo "10-dhcpd-restart running with \$interface and \$status"
if [[ "\$2" == "up" ]]; then
  if [[ \$(grep "\$1" /etc/default/isc-dhcp-server | grep "INTERFACESv4") ]]; then
    echo "Restarting dhcpd"
    systemctl restart isc-dhcp-server
  fi
fi
EOF
chmod +x /etc/NetworkManager/dispatcher.d/10-dhcpd-restart

netplan apply

echo "Please reboot system"
