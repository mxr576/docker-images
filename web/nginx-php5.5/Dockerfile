FROM ubuntu:14.04

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Set timezone and locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN \
    # Update system
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    # Install packages
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install php5-fpm php5-mysql php5-imagick \
    php5-mcrypt php5-curl php5-cli php5-gd php5-sqlite php5-common php-apc \
    php-pear php5-json php5-memcache \
    mysql-client supervisor \
    nginx && \
    # Cleanup
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN php5enmod mcrypt

# Configuration
ADD ./config/nginx.conf /etc/nginx/nginx.conf
ADD ./config/includes/drupal.conf /etc/nginx/conf.d/includes/drupal.conf
ADD ./config/default /etc/nginx/sites-available/default
ADD ./config/realip.conf /etc/nginx/conf.d/realip.conf
ADD ./config/supervisor.conf /etc/supervisor/conf.d/supervisord-nginx.conf

# Generate SSL certificate and key
RUN openssl req -batch -nodes -newkey rsa:2048 -keyout /etc/ssl/private/server.key -out /tmp/server.csr && \
    openssl x509 -req -days 365 -in /tmp/server.csr -signkey /etc/ssl/private/server.key -out /etc/ssl/certs/server.crt;rm /tmp/server.csr

RUN \
    # PHP settings changes
    sed -i 's/memory_limit = .*/memory_limit = 196M/' /etc/php5/fpm/php.ini && \
    sed -i 's/cgi.fix_pathinfo = .*/cgi.fix_pathinfo = 0/' /etc/php5/fpm/php.ini && \
    sed -i 's/upload_max_filesize = .*/upload_max_filesize = 500M/' /etc/php5/fpm/php.ini && \
    sed -i 's/post_max_size = .*/post_max_size = 500M/' /etc/php5/fpm/php.ini && \
    # PHP FPM config changes
    sed -i 's/listen = .*/listen = \/var\/run\/php5-fpm\.sock/' /etc/php5/fpm/pool.d/www.conf && \
    sed -i "/;listen.owner = www-data/c\listen.owner = www-data" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "/;listen.group = www-data/c\listen.group = www-data" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "/;listen.mode = 0666/c\listen.mode = 0666" /etc/php5/fpm/pool.d/www.conf && \
    sed -i "/;daemonize = yes/c\daemonize = no" /etc/php5/fpm/php-fpm.conf

# Startup script
# This startup script wll configure nginx
ADD ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

RUN mkdir /var/www

ADD ./config/index.php /var/www/docroot/index.php

RUN usermod -u 1000 www-data && \
    chown -R www-data:www-data /var/www

EXPOSE 80 443

WORKDIR /var/www

CMD /opt/startup.sh; /usr/bin/supervisord -n
