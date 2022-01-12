#!/bin/bash

SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

# sudo -H -u $OWNER bash -c "export XDG_CURRENT_DESKTOP=XFCE ; export TERM=xterm ; wget -O - https://raw.githubusercontent.com/laurent22/joplin/master/Joplin_install_and_update.sh | bash"

flatpak install -y --noninteractive flathub net.cozic.joplin_desktop;

cd $SCRIPTPATH;
