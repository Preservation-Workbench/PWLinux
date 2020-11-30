#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
APPS=/home/$OWNER/.local/share/applications
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
URL=https://github.com/sfa-siard/SiardGui/releases/download/2.1.34/SIARD-Suite-2.1.134.zip
SIARDDIR=/home/$OWNER/bin/dbptk

if [ ! -f $SIARDDIR/dbptk-desktop.AppImage ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $SIARDDIR;";
    sudo -H -u $OWNER bash -c "wget -O $SIARDDIR/dbptk-desktop.AppImage $URL";
    sudo -H -u $OWNER bash -c "chmod a+rx $SIARDDIR/dbptk-desktop.AppImage";
fi

SRC=$SCRIPTPATH/img/dbptk.png
FNAME=$PWCONFIGDIR/img/dbptk.png
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
fi

if [ ! -f $APPS/dbptk.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/desktop/dbptk.desktop $APPS;";
    sed -i "/Exec=dummy/c\Exec=$SIARDDIR/dbptk-desktop.AppImage" $APPS/dbptk.desktop; 
    sed -i "/Icon=dummy/c\Icon=$FNAME" $APPS/dbptk.desktop;   
    chown $OWNER:$OWNER $APPS/dbptk.desktop;  
fi

cd $SCRIPTPATH;

# wget -q -O - "https://download.bell-sw.com/pki/GPG-KEY-bellsoft" | sudo apt-key add -
# echo "deb [arch=amd64] https://apt.bell-sw.com/ stable main" | sudo tee /etc/apt/sources.list.d/bellsoft.list
# sudo apt-get update
# sudo apt-get install bellsoft-java8-runtime-full


# /usr/lib/jvm/bellsoft-java8-runtime-full-amd64/bin/java  -Xmx1024m -Dsun.awt.disablegrab=true -Djava.util.logging.config.file=./etc/logging.properties -jar ./lib/siardgui.jar  
# # TODO: Fix så ikke spør om installasjon


# /usr/lib/jvm/bellsoft-java8-runtime-full-amd64/bin/java -jar dbptk-app-2.9.6.jar 




