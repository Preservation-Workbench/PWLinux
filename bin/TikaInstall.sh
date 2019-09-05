#!/bin/bash

#TODO: Lag desktop-fil/script for å åpne tika-app fra meny

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)

export VER="1.22"
sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/bin/tika";
sudo -H -u $OWNER bash -c "wget -qO /home/$OWNER/bin/tika/tika-app.jar https://archive.apache.org/dist/tika/tika-app-${VER}.jar";




