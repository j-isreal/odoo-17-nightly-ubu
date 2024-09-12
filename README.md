# odoo-17-nightly-ubu
**Odoo 17 nightly build community edition on Ubuntu Server 24.04.1 with Postgresql 16, Let's Encrypt SSL, and Nginx proxy**

This project has a complete guide on my website - see below.

This project requires an Ubuntu Server PC or VPS/KVM with the latest version of Ubuntu Server (downloads below).

This project has a Docker image and docker compose file for a quick trial.  Networking will not function properly in a container without advanced setup.  <b>For best results</b>, use the instructions and a public IP and internet domain for setup of Odoo.

<br />

<b>Ubuntu Server Downloads</b>

- Ubuntu Server for amd64: https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso
- Ubuntu Server for arm64: https://cdimage.ubuntu.com/releases/24.04/release/ubuntu-24.04.1-live-server-arm64.iso

<br />

## Complete Guide
View the complete guide on my website:

- https://www.jinet.us/dev/dev-projects/setting-up-odoo-17-ubuntu/

<br/>

## install-odoo.sh Install Script
The ```install-odoo.sh``` BASH script installs all the dependencies and the nightly build of Odoo 17 community.  It also customizes the configuration, installs Nginx proxy, installs SSL certificates, and starts services.  _This script should be run as root._

- **This script presumes that you have a fresh install of Ubuntu 24.04 amd64.**

- If you have a different system architecture (like arm64 for Raspberry Pi), new scripts will be coming soon.


Make the script executable with:
```
chmod +x install-odoo.sh
```

Then, run the script with:
```
./install-odoo.sh
```

Follow the on-screen directions to complete the install.

<br/>


## Docker Images
I'm creating a Docker image for use with this project since there is no Odoo 17 Ubuntu 24.04 Docker image yet.

- [Docker README.md](https://github.com/j-isreal/odoo-17-nightly-ubu/blob/main/docker/README.md)

<br/><br/>
### Visit my website

https://www.jinet.us/dev/dev-projects/

Copyright &copy; 2024 Jacob Eiler, Isreal Consulting, LLC.  All rights reserved.

