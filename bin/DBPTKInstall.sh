#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
APPS=/home/$OWNER/.local/share/applications
URL=https://github.com/keeps/dbptk-desktop/releases/download/v2.5.4/dbptk-desktop-2.5.4.AppImage
DBPTKDIR=/home/$OWNER/bin/dbptk

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

cd $SCRIPTPATH;




