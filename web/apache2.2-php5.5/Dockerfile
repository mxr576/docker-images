FROM blinkreaction/drupal-web-base

# Adding https://launchpad.net/~ondrej/+archive/ubuntu/php5 PPA repo for php5.5
RUN echo "deb http://ppa.launchpad.net/ondrej/php5/ubuntu precise main " >> /etc/apt/sources.list

# Tell DPKG to keep the old config file to prevent installation error "Modified (by you or by a script) since installation."
RUN echo "Dpkg::Options { \"--force-confdef\"; \"--force-confold\"; }" >> /etc/apt/apt.conf.d/local

# Upgrade php5.3 to php5.5
RUN \
    # Update system
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    # Re-Install packages
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y --force-yes --reinstall install php5-fpm php5-mysql php5-imagick php5-imap \
    php5-mcrypt php5-curl php5-cli php5-gd php5-sqlite php5-common php-apc \
    php-pear php5-json php5-memcache && \
    # Cleanup
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoclean && apt-get -y autoremove
