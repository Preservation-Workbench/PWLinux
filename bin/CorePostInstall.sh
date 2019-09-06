#!/bin/bash

apt remove -y hexchat-common hexchat thunderbird rhythmbox tomboy xplayer xfce4-taskmanager;

#pip3 install -U autopep8 --user
#python3 -m pip install -U rope --user

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
sudo -H -u $OWNER bash -c "python3 -m pip install -U ttkthemes unoconv execsql epc --user";

if [ $(dpkg-query -W -f='${Status}' ripgrep 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget -qO /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb;
    apt-get install -y /tmp/ripgrep.deb;
fi

cat <<\EOF > /home/$OWNER/bin/div_fix.sh
#! /bin/bash
pkill gvfsd-fuse && /usr/lib/gvfs/gvfsd-fuse -o allow_other /var/run/user/1000/gvfs/
setxkbmap -option 'numpad:microsoft'
#"$ORACLE_HOME"/bin/lsnrctl start && sudo /etc/init.d/oracle-xe start
EOF
chmod a+rx /home/$OWNER/bin/div_fix.sh

echo "[Desktop Entry]
Type=Application
Exec=/home/$OWNER/bin/div_fix.sh
Hidden=false
X-MATE-Autostart-enabled=true
Name=Div_Fix" > /home/$OWNER/.config/autostart/Div_Fix.desktop


