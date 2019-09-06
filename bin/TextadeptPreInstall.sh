#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' libpng12-0 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget -qO /tmp/package_dep.deb http://security.ubuntu.com/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1.1_amd64.deb;
    apt-get install -y /tmp/package_dep.deb;
fi
