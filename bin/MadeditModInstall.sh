#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' madedit-mod 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget -qO /tmp/package_dep.deb https://sourceforge.net/projects/madedit-mod/files/0.4.17/madedit-mod_0.4.17-1_amd64_ubuntu%2018.04.deb/download;
    apt-get install -y /tmp/package_dep.deb;
fi

