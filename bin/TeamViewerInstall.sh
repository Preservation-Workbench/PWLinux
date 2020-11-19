#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))

cd /tmp
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
apt-get install -y /tmp/teamviewer_amd64.deb 

cd $SCRIPTPATH;