#!/bin/bash

sudo apt-get remove --purge `dpkg -l | grep '^rc' | awk '{print $2}'` #Remove residual config
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;

