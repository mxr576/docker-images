FROM ubuntu:12.04

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Set timezone and locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

# Adding trusty repository for latest versions
RUN sed -i 's/precise/trusty/' /etc/apt/sources.list

RUN \
    # Update system
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    # Install packages
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install locales \
    php5-fpm php5-mysql php5-imagick php5-imap \
    php5-mcrypt php5-curl php5-cli php5-gd php5-sqlite php5-common php-apc \
    php-pear php5-json php5-memcache \
    curl wget zip git mysql-client ruby-full rlwrap \
    sudo build-essential && \
    # Cleanup
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Bundler
RUN gem install bundler

# Node JS 0.12.0
RUN curl https://deb.nodesource.com/node012/pool/main/n/nodejs/nodejs_0.12.0-1nodesource1~wheezy1_amd64.deb > node.deb \
    && dpkg -i node.deb \
    && rm node.deb

# Grunt, Bower
RUN npm install -g grunt-cli bower

# Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    echo '\n#Composer \nexport PATH="$HOME/.composer/vendor/bin:$PATH"\n' >> ~/.bashrc

# Drush
RUN composer global require drush/drush:dev-master

RUN \
    # PHP settings changes
    sed -i 's/memory_limit = .*/memory_limit = 196M/' /etc/php5/fpm/php.ini && \
    sed -i 's/cgi.fix_pathinfo = .*/cgi.fix_pathinfo = 0/' /etc/php5/fpm/php.ini && \
    sed -i 's/upload_max_filesize = .*/upload_max_filesize = 500M/' /etc/php5/fpm/php.ini && \
    sed -i 's/post_max_size = .*/post_max_size = 500M/' /etc/php5/fpm/php.ini

WORKDIR /var/www

# Home directory for bundle installs
ENV BUNDLE_PATH .bundler
