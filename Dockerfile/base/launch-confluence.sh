#!/bin/bash

set -x

# Container ENV
# =============
# - APPLICATION_DOMAIN
# - CONFLUENCE_VERSION
# - CONFLUENCE_MEMORY

export CONFLUENCE_DOWNLOAD_FILE=atlassian-confluence-${CONFLUENCE_VERSION?}.tar.gz
export CONFLUENCE_DOWNLOAD_URL="http://www.atlassian.com/software/confluence/downloads/binary/${CONFLUENCE_DOWNLOAD_FILE}"
export CONFLUENCE_INSTALL_PATH=$(pwd)
export CONFLUENCE_APP_LINK=confluence-app
export CONFLUENCE_APP_PATH=$CONFLUENCE_INSTALL_PATH/$(basename $CONFLUENCE_DOWNLOAD_FILE .tar.gz)
export CONFLUENCE_HOME_PATH=$CONFLUENCE_INSTALL_PATH/confluence-data/home

# Download and extract source.
if [ ! -f $CONFLUENCE_APP_PATH ] ; then
  wget -O $CONFLUENCE_DOWNLOAD_FILE $CONFLUENCE_DOWNLOAD_URL
  tar -xzf $CONFLUENCE_DOWNLOAD_FILE
  ln -s $CONFLUENCE_APP_PATH ./$CONFLUENCE_APP_LINK
  rm -f $CONFLUENCE_DOWNLOAD_FILE
fi

# Set home (data) directory.
mkdir -p $CONFLUENCE_HOME_PATH
chmod -R 777 $CONFLUENCE_HOME_PATH
echo "confluence.home=${CONFLUENCE_HOME_PATH}/" > $CONFLUENCE_APP_PATH/confluence/WEB-INF/classes/confluence-init.properties

# Set memory in setenv.sh
sed -i s/1024m/${CONFLUENCE_MEMORY}/g $CONFLUENCE_APP_PATH/bin/setenv.sh

# Copy database driver(s) to current installation.
cp -f /usr/lib/mysql-connector-java-*-bin.jar $CONFLUENCE_APP_PATH/confluence/WEB-INF/lib/

# Add server.xml to current installation.
cp -f server.xml $CONFLUENCE_APP_PATH/conf/server.xml

# Set variables in server.xml
SERVER_XML_VARS=(
  APPLICATION_DOMAIN
)
for x in "${SERVER_XML_VARS[@]}"
do
  sed -i s/%${x}%/${!x}/g $CONFLUENCE_APP_PATH/conf/server.xml
done

# Set permissions.
chmod -R go+w $CONFLUENCE_APP_PATH

# Launch Confluence.
umask 0000
$CONFLUENCE_APP_PATH/bin/start-confluence.sh -fg
