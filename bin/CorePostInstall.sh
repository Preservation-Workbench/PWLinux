#!/bin/bash

apt remove -y hexchat-common hexchat thunderbird rhythmbox tomboy xplayer xfce4-taskmanager;

#pip3 install -U autopep8 --user
#python3 -m pip install -U rope --user

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
sudo -H -u $OWNER bash -c "python3 -m pip install -U ttkthemes unoconv execsql epc --user";

wget -qO /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb;
apt-get install -y /tmp/ripgrep.deb;


