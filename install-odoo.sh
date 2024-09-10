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
# Last updated: 09-10-2024
#

# VARIABLES
