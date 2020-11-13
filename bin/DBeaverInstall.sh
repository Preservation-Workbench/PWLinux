#!/bin/bash

isInFile=$(cat /etc/apt/sources.list.d/dbeaver.list | grep -c "https://dbeaver.io/debs/dbeaver-ce")
if [ $isInFile -eq 0 ]; then
    wget --quiet -O - https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -;
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list;
fi

apt-get update;
apt-get install -y dbeaver-ce;

# TODO: Legg til som pinned i xfce dock


