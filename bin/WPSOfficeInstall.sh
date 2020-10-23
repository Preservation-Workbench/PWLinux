#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)

sudo -H -u $OWNER bash -c "flatpak install -y flathub com.wps.Office";
