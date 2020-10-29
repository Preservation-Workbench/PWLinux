#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

if [ ! -f /tmp/microsoft.gpg ]; then
    cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
    install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg;
fi

isInFile=$(cat /etc/apt/sources.list.d/teams.list | grep -c "https://packages.microsoft.com/repos/ms-teams")
if [ $isInFile -eq 0 ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list;
    apt-get update;
fi

apt-get install -y teams;

