#!/bin/bash
killall synaptic

sudo mintupdate-cli -y --keep-configuration upgrade;
apt autoremove -y;
sudo apt-get remove --purge `dpkg -l | grep '^rc' | awk '{print $2}'` #Remove residual config
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;

