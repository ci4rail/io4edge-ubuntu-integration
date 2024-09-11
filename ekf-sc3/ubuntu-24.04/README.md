# EKF SC3 Ubuntu 24.04 Integration

This integration script is used to setup Ubuntu 24.04 hosts to use io4edge devices.

On host, ensure `curl` is installed
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