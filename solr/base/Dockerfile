FROM ubuntu:12.04

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# Set timezone and locale.
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN \
    # Update system
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    # Install packages
    DEBIAN_FRONTEND=noninteractive \
    apt-get install -y curl openjdk-7-jre-headless wget && \
    # Cleanup
    DEBIAN_FRONTEND=noninteractive apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8983

# Persist volume for solr home
VOLUME ["/var/lib/solr/data"]

# Add install script for SOLRs
ADD ./install.sh /opt/install.sh
RUN chmod +x /opt/install.sh

# Add startup script for SOLRs
ADD ./startup.sh /opt/startup.sh
RUN chmod +x /opt/startup.sh
