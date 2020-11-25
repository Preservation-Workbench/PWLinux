#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
REPOSRC="https://github.com/Preservation-Workbench/PWCode"
LOCALREPO="/home/$OWNER/bin/PWCode"

sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" 2> \
    /dev/null || git -C "$LOCALREPO" pull;";

RELPATH=$(realpath --relative-to=$SCRIPTPATH $LOCALREPO/bin) 
sudo -H -u $OWNER bash -c "source $RELPATH/installers.sh --install;";

cd $SCRIPTPATH;


