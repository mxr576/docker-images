FROM ubuntu:12.04

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Set timezone and locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# multiverse repository required to install libapache2-mod-fastcgi
RUN echo "deb http://archive.ubuntu.com/ubuntu precise multiverse" >> /etc/apt/sources.list

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN \
    # Update system
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    # Install packages
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install php5-fpm php5-mysql php5-imagick php5-imap \
    php5-mcrypt php5-curl php5-cli php5-gd php5-sqlite php5-common php-apc \
    php-pear php5-json php5-memcache \
    git curl mysql-client supervisor \
    apache2-mpm-worker libapache2-mod-fastcgi && \
    # Cleanup
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN a2enmod actions alias fastcgi rewrite ssl && \
    a2ensite default-ssl

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    echo '\n#Composer \nexport PATH="$HOME/.composer/vendor/bin:$PATH"\n' >> ~/.bashrc

# Drush
RUN composer global require drush/drush:dev-master

# Configuration
ADD ./config/default /etc/apache2/sites-available/default
ADD ./config/default-ssl /etc/apache2/sites-available/default-ssl
ADD ./config/host.conf /etc/apache2/sites-available/includes/host.conf
ADD ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./config/fastcgi.conf /etc/apache2/mods-enabled/fastcgi.conf

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
# This startup script will configure apache
ADD ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

ADD ./config/index.php /var/www/index.php

RUN usermod -u 1000 www-data && \
    mkdir -p /var/run/apache2/fastcgi/dynamic && \
    chown -R www-data:www-data /var/run/apache2 && \
    chown -R www-data:www-data /var/www

EXPOSE 80 443

WORKDIR /var/www

CMD /opt/startup.sh; /usr/bin/supervisord -n
