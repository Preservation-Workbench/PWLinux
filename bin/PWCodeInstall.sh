#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

REPOSRC="https://github.com/Preservation-Workbench/PWCode"
LOCALREPO="/home/$OWNER/bin/PWCode"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" 2> \
    /dev/null || git -C "$LOCALREPO" pull;";

source $LOCALREPO/bin/installers.sh
sudo -H -u $OWNER bash -c "install_python_runtime";
sudo -H -u $OWNER bash -c "install_python_packages";
sudo -H -u $OWNER bash -c "install_java";
sudo -H -u $OWNER bash -c "install_jars";
sudo -H -u $OWNER bash -c "install_ojdbc";

cd $SCRIPTPATH;



