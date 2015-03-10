FROM ubuntu:12.04

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Set timezone and locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
# Memcached can not run as root
RUN groupadd -r memcache && useradd -r -g memcache memcache

# Prevent services autoload (http://jpetazzo.github.io/2013/10/06/policy-rc-d-do-not-start-services-automatically/)
RUN echo '#!/bin/sh\nexit 101' > /usr/sbin/policy-rc.d && chmod +x /usr/sbin/policy-rc.d

RUN \
    # Update system
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get dist-upgrade -y && \
    # Install packages
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install memcached && \
    # Cleanup
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Startup script
# This startup script will configure apache
ADD ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh

EXPOSE 11211

ENV MEMCACHED_MEMORY_LIMIT 64

CMD memcached -u memcache -m $MEMCACHED_MEMORY_LIMIT -c 1024 -f 1.25 -t 1 -D :
