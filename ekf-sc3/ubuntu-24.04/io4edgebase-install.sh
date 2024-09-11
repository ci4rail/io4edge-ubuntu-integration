#!/bin/bash

set -e
set -x

apt-get update
apt -y --no-install-recommends install \
    isc-dhcp-server

HOST_ARCH=amd64
IO4EDGE_CLIENT_GO_VERSION="v1.8.0"

wget https://github.com/ci4rail/io4edge-client-go/releases/download/${IO4EDGE_CLIENT_GO_VERSION}/io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz && \
tar -C /usr/local/bin -xvf io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz io4edge-cli && \
rm io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz

# wget https://github.com/ci4rail/io4edge-client-go/releases/download/${IO4EDGE_CLIENT_GO_VERSION}/binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz && \
# tar -C /usr/local/bin -xvf binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz binaryIoTypeA_blinky && \
# rm binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz


# USB io4edge devices udev rules

# SLOT1 = CPU
# SLOT2 = First FAT PIPE SLOT
# SLOT3 = Second FAT PIPE SLOT (missing on my backplane)
# SLOT4 = First normal peripheral slot
# SLOT5 = Second normal peripheral slot
# ...

echo 'ACTION=="add", ATTRS{interface}=="TinyUSB Network", PROGRAM="/usr/bin/usb_io4edge_interface_name.sh %k", NAME="%c"' > /etc/udev/rules.d/99-usb-io4edge.rules

cat <<EOF > /usr/bin/usb_io4edge_interface_name.sh 
#!/bin/sh

USB_PATH=\$(readlink /sys/class/net/\$1)

USB_PORT=\$(echo \$USB_PATH | awk -F/ '{print\$(NF-3)}')

case \$USB_PORT in
  # CPCI-S0 SLOT2
  3-3)
    echo "io4edge-slot2"
    ;;
  3-3.1)
    echo "io4edge-slot2.1"
    ;;
  3-3.2)
    echo "io4edge-slot2.2"
    ;;

  # CPCI-S0 SLOT4
  3-9)
    echo "io4edge-slot4"
    ;;
  3-9.1)
    echo "io4edge-slot4.1"
    ;;
  3-9.2)
    echo "io4edge-slot4.2"
    ;;

  # CPCI-S0 SLOT5
  3-10)
    echo "io4edge-slot5"
    ;;
  3-10.1)
    echo "io4edge-slot5.1"
    ;;
  3-10.2)
    echo "io4edge-slot5.2"
    ;;

  # CPCI-S0 SLOT6
  3-13)
    echo "io4edge-slot6"
    ;;
  3-13.1)
    echo "io4edge-slot6.1"
    ;;
  3-13.2)
    echo "io4edge-slot6.2"
    ;;

# CPCI-S0 SLOT7
  3-14)
    echo "io4edge-slot7"
    ;;
  3-14.1)
    echo "io4edge-slot7.1"
    ;;
  3-14.2)
    echo "io4edge-slot7.2"
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
    io4edge-slot2:
      dhcp4: false
      addresses: [192.168.200.10/24]
    io4edge-slot2.1:
      dhcp4: false
      addresses: [192.168.201.10/24]
    io4edge-slot2.2:
      dhcp4: false
      addresses: [192.168.202.10/24]
    io4edge-slot4:
      dhcp4: false
      addresses: [192.168.203.10/24]
    io4edge-slot4.1:
      dhcp4: false
      addresses: [192.168.204.10/24]
    io4edge-slot4.2:
      dhcp4: false
      addresses: [192.168.205.10/24]
    io4edge-slot5:
      dhcp4: false
      addresses: [192.168.206.10/24]
    io4edge-slot5.1:
      dhcp4: false
      addresses: [192.168.207.10/24]
    io4edge-slot5.2:
      dhcp4: false
      addresses: [192.168.208.10/24]
    io4edge-slot6:
      dhcp4: false
      addresses: [192.168.209.10/24]
    io4edge-slot6.1:
      dhcp4: false
      addresses: [192.168.210.10/24]
    io4edge-slot6.2:
      dhcp4: false
      addresses: [192.168.211.10/24]
    io4edge-slot7:
      dhcp4: false
      addresses: [192.168.212.10/24]
    io4edge-slot7.1:
      dhcp4: false
      addresses: [192.168.213.10/24]
    io4edge-slot7.2:
      dhcp4: false
      addresses: [192.168.214.10/24]
EOF

cat <<EOF > /etc/dhcp/dhcpd.conf
ddns-update-style none;

# option definitions common to all supported networks... (not relevant for this snippet)
option domain-name "example.org";
option domain-name-servers ns1.example.org, ns2.example.org;

default-lease-time 600;
max-lease-time 7200;

subnet 192.168.200.0 netmask 255.255.255.0 {
    range 192.168.200.1 192.168.200.1;
}
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

EOF

cat <<EOF > /etc/default/isc-dhcp-server
INTERFACESv4="io4edge-slot2 io4edge-slot2.1 io4edge-slot2.2 io4edge-slot4 io4edge-slot4.1 io4edge-slot4.2 io4edge-slot5 io4edge-slot5.1 io4edge-slot5.2 io4edge-slot6 io4edge-slot6.1 io4edge-slot6.2 io4edge-slot7 io4edge-slot7.1 io4edge-slot7.2"
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
