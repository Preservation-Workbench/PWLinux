#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
APPS=/home/$OWNER/.local/share/applications
VERADIR=/home/$OWNER/bin/verapdf

if [ ! -f $VERADIR/verapdf-gui ]; then
    rm -rdf /tmp/verapdf*
    cp $SCRIPTPATH/data/verapdf/auto.xml /tmp/auto.xml;
    sed -i "s#<installpath></installpath>#<installpath>$VERADIR</installpath>#" /tmp/auto.xml;
    sudo -H -u $OWNER bash -c '
    mkdir -p '"$VERADIR"';
    wget -O /tmp/verapdf-installer.zip http://downloads.verapdf.org/rel/verapdf-installer.zip
    unzip /tmp/verapdf-installer.zip -d /tmp/verapdf;
    java -jar /tmp/verapdf/verapdf-greenfield-*/verapdf-izpack-installer-* '"$SCRIPTPATH"' /tmp/auto.xml;
    ln -s '"$VERADIR"'/verapdf /home/'"$OWNER"'/bin/verapdf.sh;'
fi

SRC=$SCRIPTPATH/img/vera.png
FNAME="$PWCONFIGDIR/img/vera.png"
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $PWCONFIGDIR/img;";
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
fi

if [ ! -f $APPS/vera.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/desktop/vera.desktop $APPS;";
    sed -i "/Exec=dummy/c\Exec=$VERADIR/verapdf-gui" $APPS/vera.desktop; 
    sed -i "/Icon=dummy/c\Icon=$FNAME" $APPS/vera.desktop;   
    chown $OWNER:$OWNER $APPS/vera.desktop;  
fi

cd $SCRIPTPATH;

