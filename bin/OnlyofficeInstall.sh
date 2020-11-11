#!/bin/bash
killall synaptic;

isInFile=$(cat /etc/apt/sources.list | grep -c "https://download.onlyoffice.com/repo/debian")
if [ $isInFile -eq 0 ]; then
    curl -sSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe09ca29f6e178040ef22b4098320ca65cb2de8e5' | apt-key add -;
    echo "deb https://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list;
fi

apt-get update;
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;
apt-get install -y ttf-mscorefonts-installer onlyoffice-desktopeditors;

# Workaround unreliable sourceforge server redirect:
mkdir -p "/tmp/winfonts"
TMP="/tmp/winfonts" && cd "$TMP"
awk '/Url/ {system("wget "$2)}' /usr/share/package-data-downloads/ttf-mscorefonts-installer
/usr/lib/msttcorefonts/update-ms-fonts "$TMP"/*
touch /var/lib/update-notifier/package-data-downloads/ttf-mscorefonts-installer
rm -r "$TMP"

