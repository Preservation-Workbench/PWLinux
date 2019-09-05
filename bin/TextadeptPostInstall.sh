#!/bin/bash

apt-get remove -y xed;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
TA_DIR="/home/$OWNER/.textadept"
if [ ! -d "$TA_DIR/.git/" ]; then
    sudo -H -u $OWNER bash -c "git clone --no-checkout https://github.com/BBATools/TextadeptSettings.git $TA_DIR/tmp";
    sudo -H -u $OWNER bash -c "mv $TA_DIR/tmp/.git $TA_DIR";
    sudo -H -u $OWNER bash -c "rmdir $TA_DIR/tmp";
    sudo -H -u $OWNER bash -c "cd $TA_DIR && git reset --hard HEAD";
fi

xdg-mime default textadept.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++



