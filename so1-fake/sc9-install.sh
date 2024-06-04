#!/bin/bash

set -e
set -x

apt-get update
apt -y --no-install-recommends install \
    isc-dhcp-server

HOST_ARCH=amd64
IO4EDGE_CLIENT_GO_VERSION="v1.8.0"
wget https://github.com/ci4rail/io4edge-client-go/releases/download/${IO4EDGE_CLIENT_GO_VERSION}/io4edge-cli-${IO4EDGE_CLI_VERSION}-linux-${HOST_ARCH}.tar.gz && \
tar -C /usr/local/bin -xvf io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz io4edge-cli && \
rm io4edge-cli-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz

wget https://github.com/ci4rail/io4edge-client-go/releases/download/${IO4EDGE_CLIENT_GO_VERSION}/binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz && \
tar -C /usr/local/bin -xvf binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz binaryIoTypeA_blinky && \
rm binaryIoTypeA_blinky-${IO4EDGE_CLIENT_GO_VERSION}-linux-${HOST_ARCH}.tar.gz


# USB io4edge devices udev rules
echo 'ACTION=="add", ATTRS{interface}=="TinyUSB Network", PROGRAM="/usr/bin/usb_io4edge_interface_name.sh %k", NAME="%c"' > /etc/udev/rules.d/99-usb-io4edge.rules

cat <<EOF > /usr/bin/usb_io4edge_interface_name.sh 
#!/bin/sh

USB_PATH=\$(readlink /sys/class/net/\$1)

USB_PORT=\$(echo \$USB_PATH | awk -F/ '{print\$(NF-3)}')

case \$USB_PORT in
  # This is the USB path where SO1 fake is connected to 
  3-6)
    echo "io4edge-1"
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
    io4edge-1:
      dhcp4: false
      addresses: [192.168.200.10/24]
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
EOF

cat <<EOF > /etc/default/isc-dhcp-server
INTERFACESv4="io4edge-1"
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
