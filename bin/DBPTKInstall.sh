#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
APPS=/home/$OWNER/.local/share/applications
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
TAG="v2.5.4"
VER="2.5.4"
URL=https://github.com/keeps/dbptk-desktop/releases/download/${TAG}/dbptk-desktop-${VER}.AppImage
DBPTKDIR=/home/$OWNER/bin/dbptk

# Install desktop and viewer:
if [ ! -f $DBPTKDIR/dbptk-desktop.AppImage ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $DBPTKDIR;";
    sudo -H -u $OWNER bash -c "wget -O $DBPTKDIR/dbptk-desktop.AppImage $URL";
    sudo -H -u $OWNER bash -c "chmod a+rx $DBPTKDIR/dbptk-desktop.AppImage";
fi

SRC=$SCRIPTPATH/img/dbptk.png
FNAME=$PWCONFIGDIR/img/dbptk.png
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
fi

if [ ! -f $APPS/dbptk.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/desktop/dbptk.desktop $APPS;";
    sed -i "/Exec=dummy/c\Exec=$DBPTKDIR/dbptk-desktop.AppImage" $APPS/dbptk.desktop; 
    sed -i "/Icon=dummy/c\Icon=$FNAME" $APPS/dbptk.desktop;   
    chown $OWNER:$OWNER $APPS/dbptk.desktop;  
fi


# WAIT: Flytt evt til PWCode installer når klart om denne skal brukes derfra
# install CLI:
TAG="v2.9.6"
VER="2.9.6"
URL=https://github.com/keeps/dbptk-developer/releases/download/${TAG}/dbptk-app-${VER}.jar

if [ ! -f $DBPTKDIR/dbptk-app.jar ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $DBPTKDIR;";
    sudo -H -u $OWNER bash -c "wget -O $DBPTKDIR/dbptk-app.jar $URL";
fi

cd $SCRIPTPATH;




