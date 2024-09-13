#!/bin/bash
#
# bash script to install Odoo 17 nightly build on
# Ubuntu 24.04 with Nginx, Postgresql 16, SSL, and automated
# nightly backup cron
#
# see following links for details:
# - DO Spaces: https://docs.digitalocean.com/products/spaces/
# - DO Spaces using s3cmd: https://docs.digitalocean.com/products/spaces/reference/s3cmd-usage/
# - s3cmd usage: https://s3tools.org/usage
#
# Written by: Jacob Isreal, Isreal Consulting LLC (www.icllc.cc)
#             jisreal@icllc.cc
#
# Last updated: 09-12-2024
#

# VARIABLES ########################################################
#
# set your domain, email address for certbot SSL and Nginx config
# BE SURE you have a DNS A-record pointing to the IP of the domain
#
DOMAIN=yoursitedomain.com
EMAIL=email@yourdomain.com
#
####################################################################

RELEASE=noble

# make sure config files we depend on exist
if [[ ! -f odoo-site.conf ]]; then
   echo "Necessary file odoo-site.conf does not exist!"
   echo "Please download or clone the entire git repo with:"
   echo "  git clone --recursive https://github.com/j-isreal/odoo-17-nightly-ubu.git"
   echo " "
   exit
fi

# let the user know some things before continuing
echo " "
echo "========================================================"
echo "ABOUT TO UPDATE SYSTEM AND RUN ODOO 17 INSTALL!"
echo "________________________________________________________"
echo " "

# make sure user is running on amd64 - more architecture scripts coming soon
ARCHITECTURE=""
case $(uname -m) in
    i386 | i686)   ARCHITECTURE="386" ; echo "Invalid system architecture.  Exiting..." ; echo " "; exit 1 ;;
    x86_64) ARCHITECTURE="amd64" ;;
    arm | aarch64)    dpkg --print-architecture | grep -q "arm64" && ARCHITECTURE="arm64" || ARCHITECTURE="arm" ; echo "Invalid system architecture.  Exiting..."; echo " "; exit 1 ;;
    *)   echo "Unable to determine system architecture.  Exiting..."; echo " "; exit 1 ;;
esac

# IF we make it to here, the architecture is amd64 and we continue...
echo "This script will update your system, and then install"
echo "all the dependencies and software required to run Odoo"
echo "community edition version 17, nightly build edition."
echo " "
echo "* If you do not want to do this, press CTRL-C now! *"
echo " "
read -p "Press any key to continue... " -n 1 -r
echo
echo " "

# update Ubuntu apt and upgrade if needed
echo "* Preparing to update and upgrade system..."
echo " "
apt-get update -y && apt-get upgrade -y

# Language/locale settings
echo "* Updating language and locales..."
echo " "
LANG=en_US.UTF-8
echo $LANG UTF-8 > /etc/locale.gen && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
     locales && \
    update-locale --reset LANG=$LANG

# remove snaps - they're annoying!
echo "- Doing some light housekeeping..."
echo " "
env DEBIAN_FRONTEND=noninteractive apt-get purge snapd -y
env DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
echo "* Installing some dependencies..."
echo " "
apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        wget \
        dirmngr \
        fonts-noto-cjk \
        gnupg \
        libssl-dev \
        node-less \
        npm \
        python3-magic \
        python3-num2words \
        python3-odf \
        python3-pdfminer \
        python3-pip \
        python3-phonenumbers \
        python3-pyldap \
        python3-qrcode \
        python3-renderpm \
        python3-setuptools \
        python3-slugify \
        python3-vobject \
        python3-watchdog \
        python3-xlrd \
        python3-xlwt \
        xz-utils \
        wkhtmltopdf

echo " "
echo "- Done installing dependencies.  Continuing..."
echo " "

# install latest postgresql-16 from repo
echo "* Installing Postgresql-16 database server..."
echo " "
install -d /usr/share/postgresql-common/pgdg
curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
sh -c 'echo "deb [arch=amd64, signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt noble-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
apt-get update -y
env DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends -y postgresql-16

# install the Nginx server and letsencrypt and ufw 
echo "* Installing Nginx web server, UFW firewall and cerbot for SSL..."
echo " "
env DEBIAN_FRONTEND=noninteractive apt-get install -y nginx ufw certbot python3-certbot-nginx
systemctl enable nginx

# allow Nginx Full through firewall
ufw allow "Nginx Full"
ufw allow OpenSSH

# Install Odoo
echo "* Installing Odoo nightly repo and updating..."
wget -O - https://nightly.odoo.com/odoo.key | gpg --dearmor -o /usr/share/keyrings/odoo-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/odoo-archive-keyring.gpg] https://nightly.odoo.com/17.0/nightly/deb/ ./" | tee /etc/apt/sources.list.d/odoo.list
echo "* Installing Odoo 17 from signed nightly repository..."
echo " "
apt-get update && apt-get -y install --no-install-recommends odoo

# configure the Odoo site in Nginx
cp odoo-site.conf /etc/nginx/sites-available/odoo-site.conf
# find the yoursitedomain.com entry and change to DOMAIN variable
sed -i -e "s/yoursitedomain.com/$DOMAIN/g" /etc/nginx/sites-available/odoo-site.conf

# link the file to sites-enabled
ln -s /etc/nginx/sites-available/odoo-site.conf /etc/nginx/sites-enabled/
# reload Nginx
systemctl reload nginx.service

# setup Let's Encrypt SSL cert
echo "* Installing SSL certificate..."
echo " "
certbot --nginx -n --agree-tos -d $DOMAIN -m $EMAIL

# add a line to the odoo-site.conf to upgrade connections to SSL
# find ssl_dhparam and add after that line using awk
awk -v q="'" '{print} /ssl_dhparam/ && !n {print "   add_header " q "Content-Security-Policy" q " " q "upgrade-insecure-requests" q ";"; n++}' /etc/nginx/sites-available/odoo-site.conf

# configure Odoo odoo.conf to use Nginx proxy
echo "proxy_mode = True" >> /etc/odoo/odoo.conf

# restart Nginx and Odoo
systemctl restart nginx
systemctl restart odoo

# done with setup and install
# let user know to access the domain URL over https to configure
echo "** COMPLETED Installation and Configuration!"
echo "________________________________________________________"
echo " "
echo "At this point, you should be able to access Odoo using"
echo "your domain name URL over HTTPS, i.e.:"
echo " "
echo "  https://odoo.yourdomain.com/"
echo " "
echo "Visit your Odoo site to configure your install!"
echo " "
echo "To use the automated backup script, setup s3cmd and"
echo "copy the script to your home folder.  See:"
echo "  https://github.com/j-isreal/bash-odoo-backup"
echo " "
echo "========================================================"
echo " "

