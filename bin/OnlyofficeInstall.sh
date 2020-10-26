#!/bin/bash

echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;

isInFile=$(cat /etc/apt/sources.list | grep -c "https://download.onlyoffice.com/repo/debian")
if [ $isInFile -eq 0 ]; then
    curl -sSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe09ca29f6e178040ef22b4098320ca65cb2de8e5' | sudo apt-key add -;
    echo "deb https://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list;
    apt-get update;
fi

apt install -y onlyoffice-desktopeditors;


