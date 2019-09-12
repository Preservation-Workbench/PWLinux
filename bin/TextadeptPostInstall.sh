#!/bin/bash

apt-get remove -y xed;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
TA_DIR="/home/$OWNER/.textadept"

sudo -H -u $OWNER bash -c "git clone --no-checkout https://github.com/BBATools/TextadeptSettings.git $TA_DIR/tmp; \
mv $TA_DIR/tmp/.git $TA_DIR; \
rmdir -rdf $TA_DIR/tmp; \
cd $TA_DIR && git reset --hard HEAD;"

xdg-mime default textadept.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++



