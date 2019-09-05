#!/bin/bash

apt install -y composer php-mysql;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)
URD_DIR="/home/$OWNER/bin/URD"
if [ ! -d "$URD_DIR/.git/" ]; then
    sudo -H -u $OWNER bash -c "git clone --no-checkout https://github.com/fkirkholt/urd.git $URD_DIR/tmp";
    sudo -H -u $OWNER bash -c "mv $URD_DIR/tmp/.git $URD_DIR";
    sudo -H -u $OWNER bash -c "rmdir $URD_DIR/tmp";
    sudo -H -u $OWNER bash -c "cd $URD_DIR && git reset --hard HEAD";

    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin/URD/ && composer install";
fi

