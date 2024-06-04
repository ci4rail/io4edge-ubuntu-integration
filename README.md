# io4edge-ubuntu-integration
Integration scripts to setup Ubuntu hosts to use io4edge devices

## Available integrations

### EKF SC9 with SO1-FAKE (IOU01)

Installs support to run the EKF SC9 with the SO1-FAKE (IOU01) device. 
Tested on Ubuntu 24.04 LTS.

On SC9, ensure `curl` is installed
```bash
sudo apt-get update
sudo apt install curl
```

Then execute the following command to install the integration
```bash
curl https://raw.githubusercontent.com/ci4rail/io4edge-ubuntu-integration/main/so1-fake/sc9-install.sh | sudo bash
```

Then reboot the system.

After reboot, execute the test program to verify the installation
```bash
io4edge-cli scan -f
DEVICE ID       SERVICE TYPE                    SERVICE NAME            IP:PORT
SO1-FAKE        _io4edge-core._tcp              SO1-FAKE                192.168.200.1:9999
                _io4edge_analogInTypeA._tcp     SO1-FAKE-analogInTypeA1 192.168.200.1:10000
                _io4edge_analogInTypeA._tcp     SO1-FAKE-analogInTypeA2 192.168.200.1:10001
                _io4edge_binaryIoTypeA._tcp     SO1-FAKE-binaryIoTypeA  192.168.200.1:10002
```

#### Execute binaryIO demo

First, connect an external I/O voltage as described [here](https://docs.ci4rail.com/edge-solutions/moducop/io-modules/iou01/quick-start-guide/#binary-io-demo).
    
Then execute the following command

```bash
binaryIoTypeA_blinky SO1-FAKE-binaryIoTypeA
```
You should see the LEDs blinking on the SO1-FAKE device.
