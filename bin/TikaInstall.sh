#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH)
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
APPS=/home/$OWNER/.local/share/applications
VER="1.24.1"
TIKAPATH=/home/$OWNER/bin/tika

# TODO: Change to 2.0 stable release when available
# Using alpha for now because of bug when parsing config file in alle previous versions 

if [ ! -f $TIKAPATH/tika-app.jar ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $TIKAPATH; \
    curl -o $TIKAPATH/tika-app.jar https://archive.apache.org/dist/tika/tika-app-2.0.0-ALPHA.jar;";  
    # curl -o $TIKAPATH/tika-app.jar https://archive.apache.org/dist/tika/tika-app-${VER}.jar;";    
    # curl -o /home/$OWNER/bin/tika/tika-app.jar --doh-url https://1.1.1.1/dns-query https://archive.apache.org/dist/tika/tika-app-${VER}.jar;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/data/tika/tika.config $TIKAPATH;";
fi

SRC=$SCRIPTPATH/img/apache.png
FNAME="$PWCONFIGDIR/img/apache.png"
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
fi

if [ ! -f $APPS/Tika.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/desktop/Tika.desktop $APPS;";
    sed -i "/Exec=dummy/c\Exec=/usr/bin/java -jar /home/$OWNER/bin/tika/tika-app.jar" $APPS/Tika.desktop; 
    sed -i "/Icon=dummy/c\Icon=$FNAME" $APPS/Tika.desktop;   
    chown $OWNER:$OWNER $APPS/Tika.desktop;  
fi

cd $SCRIPTPATH;

