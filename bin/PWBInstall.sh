#!/bin/bash

apt install -y wimtools python3-pandas graphviz python3-lxml python3-tk openjdk-11-jdk;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)
PWB_DIR="/home/$OWNER/bin/PWB"
sudo -H -u $OWNER bash -c "git clone --no-checkout https://github.com/BBATools/PreservationWorkbench.git $PWB_DIR/tmp; \
mv $PWB_DIR/tmp/.git $PWB_DIR; \
rmdir $PWB_DIR/tmp; \
cd $PWB_DIR && git reset --hard HEAD";

if [ ! -f $PWB_DIR/bin/sqlworkbench.jar ]; then
    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin/PWB/bin && \
    wget -qO tmp.zip https://www.sql-workbench.eu/Workbench-Build125.zip && unzip -o tmp.zip && rm tmp.zip; \
    ln -s /home/$OWNER/bin/PWB/bin/pwb /home/$OWNER/bin; \
    sed -i 's:java -jar sqlworkbench.jar:pwb:g' sqlworkbench.desktop; \
    sed -i 's:workbench32.png:/home/$OWNER/bin/PWB/bin/workbench32.png:g' sqlworkbench.desktop; \
    cp sqlworkbench.desktop /home/$OWNER/.local/share/applications/";
fi



