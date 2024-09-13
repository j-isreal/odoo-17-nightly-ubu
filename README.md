# odoo-17-nightly-ubu
**Odoo 17 nightly build community edition on Ubuntu Server 24.04.1 with Postgresql 16, Let's Encrypt SSL, and Nginx proxy**

This project has a complete guide on my website - [see below](#complete-guide).

**This project contains a submodule** for the bash-odoo-backup script.  
- Use --recursive in git clone to download everything.
- If you download the zip from web, it **will not** download the backup script.  Use ```git clone --recursive``` or [download the files here](https://github.com/j-isreal/bash-odoo-backup).

This project requires an Ubuntu Server PC or VPS/KVM with the latest version of Ubuntu Server ([downloads below](#get-ubuntu-server-2404-running)).

This project has [Docker images and docker compose](#docker-images) files for a quick trial.
- Networking will not function properly in a container without advanced setup.
- <b>For best results</b>, use the instructions in the [complete guide](#complete-guide) and a public IP and internet domain for setup of Odoo.

<br />


<br />

# Complete Guide
View the complete guide on my website:

- https://www.jinet.us/dev/dev-projects/setting-up-odoo-17-ubuntu/

<br/>

## Get Ubuntu Server 24.04 Running

First, we need a system running the latest Ubuntu Server 24.04. You can use a PC, Virtual Private Server (VPS), KVM, Virtual Machine, a Raspberry Pi – any system on which you can install an operating system. Just install the minimum system – no need to update or install any programs or services, the install-odoo.sh Install Script will handle all of that in a few moments.

<b>Ubuntu Server Downloads</b>

- Ubuntu Server for amd64: https://releases.ubuntu.com/24.04.1/ubuntu-24.04.1-live-server-amd64.iso
- Ubuntu Server for arm64: https://cdimage.ubuntu.com/releases/24.04/release/ubuntu-24.04.1-live-server-arm64.iso

<br />

Once you have installed and are logged into the basic Ubuntu Server system as root, either clone the repo for this project, or download the install script:

- You may need to install git and/or wget: ```apt-get install git wget``` on debian/ubuntu
```
git clone --recursive https://github.com/j-isreal/odoo-17-nightly-ubu.git

OR

wget https://raw.githubusercontent.com/j-isreal/odoo-17-nightly-ubu/main/install-odoo.sh
```
Next, change to the cloned folder and make the script executable:
```
cd odoo-17-nightly-ubu/
chmod +x install-odoo.sh

OR (if you just downloaded the script)

chmod +x install-odoo.sh
```

### install-odoo.sh Install Script
Once you've downloaded or cloned the Install Script, it's time to let it take care of finishing the installation and setup of Odoo 17. It's important to read the README.md file for this part. If you cloned the git repo, you can access the README.md from the cloned folder. Otherwise, continue to read this README.md file.

The ```install-odoo.sh``` BASH script installs all the dependencies and the nightly build of Odoo 17 community.  It also customizes the configuration, installs Nginx proxy, installs SSL certificates, and starts services.  

- **This script should be run as root.**

- _This script presumes that you have a fresh install of Ubuntu Server 24.04 amd64._

- **You will need a public IP address in your DNS server and the hostname/subdomain.**

- If you have a different system architecture (like arm64 for Raspberry Pi), new scripts will be coming soon.


Run the script with:
```
./install-odoo.sh
```

Follow the on-screen directions to complete the install.

<br/>


## Docker Images
I'm creating a Docker image for use with this project since there is no Odoo 17 Ubuntu Server 24.04 Docker image yet.

- [Docker README.md](https://github.com/j-isreal/odoo-17-nightly-ubu/blob/main/docker/README.md)

<br/><br/>

### Visit my website

[https://www.jinet.us/dev/dev-projects/setting-up-odoo-17-ubuntu/](https://www.jinet.us/dev/dev-projects/setting-up-odoo-17-ubuntu/)

Copyright &copy; 2024 Jacob Eiler, Isreal Consulting, LLC.  All rights reserved.

