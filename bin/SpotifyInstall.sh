#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' spotify 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    echo deb http://repository.spotify.comstable non-free | sudo tee /etc/apt/sources.list.d/spotify.list;
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4773BD5E130D1D45;
    apt-get update;
    sudo apt install -y spotify-client;
fi
