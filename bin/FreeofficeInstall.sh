#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' softmaker-freeoffice-2018 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget --quiet -O - http://shop.softmaker.com/repo/linux-repo-public.key | apt-key add -;
    echo "deb https://shop.softmaker.com/repo/apt wheezy non-free" >> /etc/apt/sources.list;
    apt-get update;
    apt-get install -y softmaker-freeoffice-2018;
fi

