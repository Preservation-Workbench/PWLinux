#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' dbeaver-ce 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget --quiet -O - https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -;
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list;
    apt-get update;
    apt-get install -y dbeaver-ce;
fi






