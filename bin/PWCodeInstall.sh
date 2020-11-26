#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
APPS=/home/$OWNER/.local/share/applications
REPOSRC="https://github.com/Preservation-Workbench/PWCode"
LOCALREPO="/home/$OWNER/bin/PWCode"

sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" 2> \
    /dev/null || git -C "$LOCALREPO" pull;";

RELPATH=$(realpath --relative-to=$SCRIPTPATH $LOCALREPO/bin) 
sudo -H -u $OWNER bash -c "source $RELPATH/installers.sh --install;";

if [ ! -f $APPS/PWCode.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $LOCALREPO/PWCode.desktop $APPS;";
    sed -i "/Exec=/c\Exec=$LOCALREPO/bin/pwcode %F" $APPS/PWCode.desktop
    sed -i "/Icon=/c\Icon=$LOCALREPO/bin/img/pwcode.gif" $APPS/PWCode.desktop;   
    chown $OWNER:$OWNER $APPS/PWCode.desktop;  
fi

if [ ! -f $APPS/SQLWB.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $LOCALREPO/bin/vendor/config/SQLWB.desktop $APPS;";
    sed -i "/Exec=/c\Exec=$LOCALREPO/bin/sqlwb" $APPS/SQLWB.desktop
    sed -i "/Icon=/c\Icon=$LOCALREPO/bin/img/sqlwb.png" $APPS/SQLWB.desktop;   
    chown $OWNER:$OWNER $APPS/SQLWB.desktop;  
fi

cd $SCRIPTPATH;

# TODO: Legg til dock for sqlwb og pwcode 

# TODO: Legg til i desktop-filer



