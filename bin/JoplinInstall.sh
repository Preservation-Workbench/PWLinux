#!/bin/bash

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

sudo -H -u $OWNER bash -c "export XDG_CURRENT_DESKTOP=XFCE ; export TERM=xterm ; wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash"


