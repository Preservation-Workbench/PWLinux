#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' onlyoffice-desktopeditors 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    curl -sSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe09ca29f6e178040ef22b4098320ca65cb2de8e5' | sudo apt-key add -;
    echo "deb https://download.onlyoffice.com/repo/debian squeeze main" > /etc/apt/sources.list;
    apt-get update;
    apt-get install -y onlyoffice-desktopeditors;
fi

