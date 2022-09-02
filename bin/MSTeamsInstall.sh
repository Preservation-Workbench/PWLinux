#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

flatpak install -y --noninteractive flathub com.github.IsmaelMartinez.teams_for_linux;

cd $SCRIPTPATH;

