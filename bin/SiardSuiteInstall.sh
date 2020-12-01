#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
APPS=/home/$OWNER/.local/share/applications
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
TAG="2.1.34"
VER="2.1.134"
URL=https://github.com/sfa-siard/SiardGui/releases/download/${TAG}/SIARD-Suite-${VER}.zip
BINDIR=/home/$OWNER/bin
SIARDDIR=$BINDIR/sfa-siard

if [ ! -f $SIARDDIR/siardgui.sh ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $SIARDDIR;";
    sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.java;";
    sudo -H -u $OWNER bash -c "echo "\""installed.version=${VER}"\"" > /home/$OWNER/.java/siard_suite_2.1.properties;";
    sudo -H -u $OWNER bash -c "wget -O /tmp/SIARD-Suite.zip $URL";
    sudo -H -u $OWNER bash -c "unzip /tmp/SIARD-Suite.zip -d $BINDIR;";
    sudo -H -u $OWNER bash -c "mv -v $BINDIR/siard_suite-*/* $SIARDDIR;";
    sudo -H -u $OWNER bash -c "rm -rdf $BINDIR/siard_suite-*/;";
fi

SRC=$SCRIPTPATH/data/siardsuite/siardgui.sh
if [ ! -f $BINDIR/siardgui.sh ]; then
    sudo -H -u $OWNER bash -c "cp $SRC $BINDIR/siardgui.sh";
fi

ICON=$SIARDDIR/doc/manual/siardgui.png
if [ ! -f $APPS/siardsuite.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/desktop/siardsuite.desktop $APPS;";
    sed -i "/Exec=dummy/c\Exec=$BINDIR/siardgui.sh" $APPS/siardsuite.desktop; 
    sed -i "/Icon=dummy/c\Icon=$ICON" $APPS/siardsuite.desktop;   
    chown $OWNER:$OWNER $APPS/siardsuite.desktop;  
fi

cd $SCRIPTPATH;



