#!/bin/bash

# Link configuration directory
rm -fr $SOLR_COLLECTION_PATH/conf
mkdir /var/lib/solr/conf
ln -s /var/lib/solr/conf $SOLR_COLLECTION_PATH/conf

# Link data directory
rm -fr $SOLR_COLLECTION_PATH/data
ln -s /var/lib/solr/data $SOLR_COLLECTION_PATH/data

# Start solr
cd /opt/solr/$SOLR/example/
java -jar start.jar
