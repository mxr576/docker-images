FROM blinkreaction/drupal-solr:base

MAINTAINER Leonid Makarov <leonid.makarov@blinkreaction.com>

# SOLR 3.x version and mirror
ENV SOLR_VERSION 3.6.2
ENV SOLR_MIRROR http://archive.apache.org/dist/lucene/solr
ENV SOLR apache-solr-$SOLR_VERSION

ENV SOLR_COLLECTION_PATH /opt/solr/$SOLR/example/solr

# Download and install solr
RUN /opt/install.sh

CMD /opt/startup.sh;
