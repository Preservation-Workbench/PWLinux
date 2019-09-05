#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
echo /home/$OWNER/lein
echo /home/$OWNER/bin/lein
wget -qO /home/$OWNER/bin/lein https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein;
chmod a+x /home/$OWNER/bin/lein;
sudo -H -u $OWNER bash -c "/home/$OWNER/bin/lein";






