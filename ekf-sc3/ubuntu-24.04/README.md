# EKF SC3 Ubuntu 24.04 Integration

This integration script is used to setup Ubuntu 24.04 hosts to use io4edge devices.

On host, ensure `curl` is installed
```bash
sudo apt-get update
sudo apt install curl
```

Then execute the following command to install the integration
```bash
curl https://raw.githubusercontent.com/ci4rail/io4edge-ubuntu-integration/main/ekf-sc3/ubuntu-24.04/io4edgebase-install.sh | sudo bash
```

Then reboot the system.

After reboot:

```
io4edge-cli scan
```
And the connected io4edge devices should be listed.