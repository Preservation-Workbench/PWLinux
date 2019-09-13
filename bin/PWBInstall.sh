#!/bin/bash

apt install -y wimtools python3-pandas graphviz python3-lxml python3-tk openjdk-11-jdk;


# TODO: Legg inn dokumentasjon på at ojdbc10.jar og sophos må lastes ned manuelt og legges i bin-katalog
#ojdbc10.jar fra her: https://www.oracle.com/database/technologies/appdev/jdbc-downloads.html
#sav-linux-free-9.tgz fra her: https://secure2.sophos.com/en-us/products/free-tools/sophos-antivirus-for-linux/download.aspx

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

# TODO: Først sjekk her på om sav allerede er installert
if ! [ -x "$(command -v savscan)" ]; then
    if [ -f $SCRIPTPATH/sav-linux-free-9.tgz ]; then
        sudo -H -u $OWNER bash -c "tar zxvf $SCRIPTPATH/sav-linux-free-9.tgz;";
        $SCRIPTPATH/sophos-av/install.sh --acceptlicence --automatic --live-protection=False --SavWebUsername=pwb --SavWebPassword=pwb --update-free=True --update-period=24 --update-type=f /opt/sophos-av;
        /opt/sophos-av/bin/savdctl disable;
        /opt/sophos-av/bin/savconfig set DisableFeedback true;
        sed -i -e 's/#user_allow_other/user_allow_other/' /etc/fuse.conf;
        rm -rdf $SCRIPTPATH/sophos-av
    fi
fi


#TODO: Bruke dette valget auto når på adm-sone: --update-proxy-address=http://85.19.187.24:8080
#valg for install: default location, ikke on-access, oppdatering fra sophos, free version,

