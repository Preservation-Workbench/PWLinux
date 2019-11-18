#!/bin/bash

if [ ! -f /etc/apt/sources.list.d/savoury1-curl34-bionic.list ]; then
    curl -sSL 'https://keyserver.ubuntu.com/pks/lookup?fingerprint=on&op=get&search=0xE996735927E427A733BB653E374C7797FB006459' | sudo apt-key add -;
    echo "deb http://ppa.launchpad.net/savoury1/curl34/ubuntu bionic main" > /etc/apt/sources.list.d/savoury1-curl34-bionic.list;
    apt-get update;
    apt-get install curl;
fi

sudo mintupdate-cli -y --keep-configuration upgrade;
apt autoremove;
sudo apt-get remove --purge `dpkg -l | grep '^rc' | awk '{print $2}'` #Remove residual config
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;

