# odoo-17-nightly-ubu
Odoo 17 nightly build community edition on Ubuntu 24.04 with Postgresql 16, Let's Encrypt SSL, and Nginx proxy


## Complete Guide
View the complete guide on my website:

- https://www.jinet.us/dev/dev-projects/setting-up-odoo-17-ubuntu/

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




## Docker Image
I'm creating a Docker image for use with this project since there is no Odoo 17 Docker image yet.

- link

<br/><br/>
### Visit my website

https://www.jinet.us/dev/dev-projects/

Copyright &copy; 2024 Jacob Eiler, Isreal Consulting, LLC.  All rights reserved.

