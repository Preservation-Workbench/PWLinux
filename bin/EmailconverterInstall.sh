#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
TAG="2.5.3"
VER="2.5.3-all"
EMAILCONVDIR=/home/$OWNER/bin/emailconverter
URL=https://github.com/nickrussler/email-to-pdf-converter/releases/download/${TAG}/emailconverter-${VER}.jar

if [ ! -f $EMAILCONVDIR/emailconverter.jar ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $EMAILCONVDIR;";
    sudo -H -u $OWNER bash -c "wget -O $EMAILCONVDIR/emailconverter.jar $URL";
fi

cd $SCRIPTPATH;



