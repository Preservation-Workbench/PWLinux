#!/bin/bash

#TODO: Lag desktop-fil/script for å åpne tika-app fra meny

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)
ver="1.22"
tika_path="/home/$OWNER/bin/lein"

if [ ! -f $tika_path/tika-app.jar ]; then
    sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/bin/tika; \
    wget -qO /home/$OWNER/bin/tika/tika-app.jar https://archive.apache.org/dist/tika/tika-app-${ver}.jar;";
fi



