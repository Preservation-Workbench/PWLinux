#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

# WAIT: Lag menyvalg + kopier eller lenke executables til path

if [ ! -f /home/$OWNER/bin/verapdf/verapdf ]; then
    rm -rdf /tmp/verapdf-*
    sudo -H -u $OWNER bash -c '
    mkdir -p /home/'"$OWNER"'/bin/verapdf;
    wget -O /tmp/verapdf-installer.zip http://downloads.verapdf.org/rel/verapdf-installer.zip
    unzip /tmp/verapdf-installer.zip -d /tmp/verapdf;
    java -jar /tmp/verapdf/verapdf-izpack-installer-* '"$SCRIPTPATH"'/data/verapdf/auto.xml;
    ln -s /home/'"$OWNER"'/bin/verapdf/verapdf /home/'"$OWNER"'/bin/verapdf.sh;'
fi

cd $SCRIPTPATH;

