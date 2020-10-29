#!/bin/bash

isInFile=$(cat /etc/apt/sources.list.d/spotify.list | grep -c "http://repository.spotify.com")
if [ $isInFile -eq 0 ]; then
    echo "deb http://repository.spotify.com stable non-free" > /etc/apt/sources.list.d/spotify.list;
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 4773BD5E130D1D45;
fi

apt-get update;
apt-get install -y spotify-client;