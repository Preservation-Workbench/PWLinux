#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
lein_path="/home/$OWNER/bin/lein"

if [ ! -f $lein_path ]; then
    wget -qO $lein_path https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein;
    chmod a+x $lein_path;
    chown $OWNER:$OWNER $lein_path;
    sudo -H -u $OWNER bash -c "$lein_path";
fi






