#!/bin/bash

cd /tmp
wget https://download.teamviewer.com/download/linux/teamviewer_amd64.deb
apt-get install -y /tmp/teamviewer_amd64.deb 