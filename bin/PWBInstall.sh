#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)
PWB_DIR="/home/$OWNER/bin/PWB"
if [ ! -d "$PWB_DIR/.git/" ]; then
    sudo -H -u $OWNER bash -c "git clone --no-checkout https://github.com/BBATools/PreservationWorkbench.git $PWB_DIR/tmp";
    sudo -H -u $OWNER bash -c "mv $PWB_DIR/tmp/.git $PWB_DIR";
    sudo -H -u $OWNER bash -c "rmdir $PWB_DIR/tmp";
    sudo -H -u $OWNER bash -c "cd $PWB_DIR && git reset --hard HEAD";
fi

#PWB:
# TODO: Oppdater med denne:
#cd ~/bin && git clone https://github.com/BBATools/PreservationWorkbench.git PWB2 &&
#cd PWB2/bin  && wget -qO- -O tmp.zip https://www.sql-workbench.eu/Workbench-Build125.zip && unzip tmp.zip && rm tmp.zip


#cd /home/bba/bin/PWB/bin
#Kopierte PWB-mappe til /home/bba/bin/PWB/bin -> TODO: Automatiser inkl linje under senere
#mkdir -p ~/bin/PWB && cd ~/bin/PWB && wget -qO- -O tmp.zip https://www.sql-workbench.eu/Workbench-Build124.zip && unzip tmp.zip && rm tmp.zip
#ln -s ~/bin/PWB/PWB.sh ~/bin
#cd ~/bin/PWB/bin
# TODO: Linjen under virket ikke -> sjekk om navn på dekstop-fil er endret
#sed -i 's:java -jar sqlworkbench.jar:PWB.sh:g' /home/bba/bin/PWB/bin/sqlworkbench.desktop
# TODO: Måtte likevel sette bildefil manuelt etterpå. Hvorfor?
#sed -i 's:workbench32.png:/home/bba/bin/PWB/bin/workbench32.png:g' /home/bba/bin/PWB/bin/sqlworkbench.desktop
#cp sqlworkbench.desktop ~/.local/share/applications/
