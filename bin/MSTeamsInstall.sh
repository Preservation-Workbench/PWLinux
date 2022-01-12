#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

# if [ ! -f /tmp/microsoft.gpg ]; then
#     cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
#     install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg;
#     # Fix for mic:
#     usermod -a -G pulse,audio $OWNER
# fi

# isInFile=$(cat /etc/apt/sources.list.d/teams.list | grep -c "https://packages.microsoft.com/repos/ms-teams")
# if [ $isInFile -eq 0 ]; then
#     echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/ms-teams stable main" > /etc/apt/sources.list.d/teams.list;
# fi

# apt-get update;
# apt-get install -y teams;

flatpak install -y --noninteractive flathub com.microsoft.Teams;

cd $SCRIPTPATH;
