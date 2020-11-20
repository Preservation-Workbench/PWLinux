#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
isInFile=$(cat /etc/apt/sources.list.d/dbeaver.list | grep -c "https://dbeaver.io/debs/dbeaver-ce")
if [ $isInFile -eq 0 ]; then
    wget --quiet -O - https://dbeaver.io/debs/dbeaver.gpg.key | apt-key add -;
    echo "deb https://dbeaver.io/debs/dbeaver-ce /" > /etc/apt/sources.list.d/dbeaver.list;
fi

apt-get update;
apt-get install -y dbeaver-ce;

DBDT="/home/$OWNER/.local/share/DBeaverData/workspace6/General/.dbeaver"
if [ ! -f "$DBDT/data-sources.json" ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $DBDT;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/data/dbeaver/data-sources.json $DBDT/data-sources.json"
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/data/dbeaver/credentials-config.json $DBDT/credentials-config.json"
fi

cd $SCRIPTPATH;


