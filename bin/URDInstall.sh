#!/bin/bash

apt install -y composer php-mysql;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)
URD_DIR="/home/$OWNER/bin/URD"

sudo -H -u $OWNER bash -c "git clone --no-checkout https://github.com/fkirkholt/urd.git $URD_DIR/tmp; \
mv $URD_DIR/tmp/.git $URD_DIR; \
rmdir -rdf $URD_DIR/tmp; \
cd $URD_DIR && git reset --hard HEAD; \
cd /home/$OWNER/bin/URD/ && composer install;";


