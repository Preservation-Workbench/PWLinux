#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)

sudo apt-get install flatpak;
sudo -H -u $OWNER bash -c "flatpak install -y flathub com.github.johnfactotum.Foliate";
