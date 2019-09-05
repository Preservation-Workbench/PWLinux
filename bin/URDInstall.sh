#!/bin/bash

apt install -y composer php-mysql;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)
URD_DIR="/home/$OWNER/bin/URD/.git/"
if [ ! -d "$URD_DIR" ]; then
    sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/bin/";
    sudo -H -u $OWNER bash -c "git clone https://github.com/fkirkholt/urd.git /home/$OWNER/bin/URD/";
    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin/URD/ && composer install";
fi

