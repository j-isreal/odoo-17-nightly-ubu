# syntax=docker/dockerfile:1
FROM ubuntu:noble
LABEL org.opencontainers.image.authors="jisreal@icllc.cc"
LABEL org.opencontainers.image.title="Odoo 17 Nightly on Ubuntu 24.04"
LABEL org.opencontainers.image.description="Docker image of Odoo 17 Nightly on Ubuntu 24.04"


# update base system
RUN apt-get update -y && apt-get upgrade -y

# Language/locale settings
ENV LANG=en_US.UTF-8
RUN echo $LANG UTF-8 > /etc/locale.gen && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
     locales && \
    update-locale --reset LANG=$LANG

# remove snaps
RUN env DEBIAN_FRONTEND=noninteractive apt-get purge snapd -y
RUN env DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge -y

# add odoo user
useradd -m -d /home/odoo17 -U -r -s /bin/bash odoo17

# install the Nginx server, config files, letsencrypt and ufw and allow Nginx Full

RUN apt install -y nginx ufw \
        certbot python3-certbot-nginx

RUN ufw allow "Nginx Full"
RUN ufw allow OpenSSH

# set domain, email address for certbot SSL and Nginx config
ENV DOMAIN=yourdomain.com
ENV EMAIL=email@yourdomain.com

COPY ./odoo-site.conf /etc/nginx/sites-available/odoo-site.conf
RUN ln -s /etc/nginx/sites-available/odoo-site.conf /etc/nginx/sites-enabled/
RUN systemctl reload nginx.service
RUN certbot --nginx -n --agree-tos -d $DOMAIN -m $EMAIL

# add following line to /etc/nginx/sites-available/odoo-site.conf
# after this line:
# ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot
#    add_header 'Content-Security-Policy' 'upgrade-insecure-requests';
# using sed
#RUN sed -e '/ssl_dhparam=/a\' -e 'add_header 'Content-Security-Policy' 'upgrade-insecure-requests';' /etc/nginx/sites-available/odoo-site.conf

# Install some deps, lessc and less-plugin-clean-css, and wkhtmltopdf
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
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

# install latest postgresql-16
RUN curl -o /etc/apt/trusted.gpg.d/postgresql.gpg --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc
RUN sh -c 'echo "deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update 
RUN apt-get install --no-install-recommends -y postgresql-16

# Install Odoo
RUN wget -O - https://nightly.odoo.com/odoo.key | gpg --dearmor -o /usr/share/keyrings/odoo-archive-keyring.gpg
RUN echo 'deb [signed-by=/usr/share/keyrings/odoo-archive-keyring.gpg] https://nightly.odoo.com/17.0/nightly/deb/ ./' | tee /etc/apt/sources.list.d/odoo.list
RUN apt-get update && apt-get -y install --no-install-recommends odoo

# Copy Odoo configuration file and set permissions
COPY ./odoo.conf /etc/odoo/
RUN chown odoo /etc/odoo/odoo.conf

# Expose Odoo services
#EXPOSE 8069 8071 8072  --  we only need port 8069
EXPOSE 8069

# Set the default config file
ENV ODOO_RC /etc/odoo/odoo.conf

# Set default user when running the container
USER odoo

CMD ["odoo"]

