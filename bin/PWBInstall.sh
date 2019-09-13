#!/bin/bash

apt install -y wimtools python3-pandas graphviz python3-lxml python3-tk openjdk-11-jdk;


# TODO: Legg inn dokumentasjon på at ojdbc10.jar må lastes ned manuelt og legges i bin-katalog


SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)

REPOSRC="https://github.com/BBATools/PreservationWorkbench.git"
LOCALREPO="/home/$OWNER/bin/PWB"
sudo -H -u $OWNER bash -c "git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull"

if [ ! -f $LOCALREPO/bin/sqlworkbench.jar ]; then
    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin/PWB/bin && \
    wget -qO tmp.zip https://www.sql-workbench.eu/Workbench-Build125.zip && unzip -o tmp.zip && rm tmp.zip; \
    ln -s /home/$OWNER/bin/PWB/bin/pwb.sh /home/$OWNER/bin; \
    sed -i 's:java -jar sqlworkbench.jar:/home/$OWNER/bin/PWB/bin/pwb.sh:g' sqlworkbench.desktop; \
    sed -i 's:workbench32.png:/home/$OWNER/bin/PWB/bin/workbench32.png:g' sqlworkbench.desktop; \
    cp sqlworkbench.desktop /home/$OWNER/.local/share/applications/";
fi

if [ ! -f $LOCALREPO/bin/ojdbc10.jar ]; then
    if [ -f $SCRIPTPATH/ojdbc10.jar ]; then
        sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/ojdbc10.jar $LOCALREPO/bin/";
    fi
fi



