#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' madedit-mod 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget -qO /tmp/package_dep.deb https://sourceforge.net/projects/madedit-mod/files/0.4.19/madedit-mod_0.4.19-1_amd64_Ubuntu19.10.deb/download;
    apt-get install -y /tmp/package_dep.deb;
fi