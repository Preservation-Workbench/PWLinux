#!/bin/bash
#WAIT: Legg inn sjekk på om snapd installert først eller alltid kjør core install først

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

snap install bluemail;

ln -s /var/lib/snapd/desktop/applications/bluemail_bluemail.desktop  /home/$OWNER/.local/share/applications;
