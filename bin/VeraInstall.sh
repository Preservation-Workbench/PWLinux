#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
VERADIR=/home/$OWNER/bin/verapdf/verapdf 

# WAIT: Lag menyvalg + kopier eller lenke executables til path

if [ ! -f $VERADIR ]; then
    rm -rdf /tmp/verapdf*
    sudo -H -u $OWNER bash -c '
    mkdir -p '"$VERADIR"';
    wget -O /tmp/verapdf-installer.zip http://downloads.verapdf.org/rel/verapdf-installer.zip
    unzip /tmp/verapdf-installer.zip -d /tmp/verapdf;
    sed -i "/<installpath></installpath>/c\<installpath>'"$VERADIR"'</installpath>" '"$SCRIPTPATH"'/data/verapdf/auto.xml; 
    java -jar /tmp/verapdf/verapdf-greenfield-*/verapdf-izpack-installer-* '"$SCRIPTPATH"'/data/verapdf/auto.xml;
    ln -s '"$VERADIR"' /home/'"$OWNER"'/bin/verapdf.sh;'
fi

cd $SCRIPTPATH;

