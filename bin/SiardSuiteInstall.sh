#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
APPS=/home/$OWNER/.local/share/applications
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
URL=https://github.com/sfa-siard/SiardGui/releases/download/2.1.34/SIARD-Suite-2.1.134.zip
BINDIR=/home/$OWNER/bin
SIARDDIR=$BINDIR/sfa-siard

isInFile=$(cat /etc/apt/sources.list.d/bellsoft.list | grep -c "https://apt.bell-sw.com/")
if [ $isInFile -eq 0 ]; then    
    wget -qO - https://download.bell-sw.com/pki/GPG-KEY-bellsoft | sudo apt-key add - 
    echo 'deb [arch=amd64] https://apt.bell-sw.com/ stable main' > /etc/apt/sources.list.d/bellsoft.list;
fi

apt-get update;
apt-get install bellsoft-java8-runtime-full;

if [ ! -f $SIARDDIR/siardgui.sh ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $SIARDDIR;";
    sudo -H -u $OWNER bash -c "wget -O /tmp/SIARD-Suite.zip $URL";
    sudo -H -u $OWNER bash -c "unzip /tmp/SIARD-Suite.zip -d $BINDIR;";
    sudo -H -u $OWNER bash -c "mv -v $BINDIR/siard_suite-*/* $SIARDDIR;";
    sudo -H -u $OWNER bash -c "rm -rdf $BINDIR/siard_suite-*/;";
fi


SRC=$SCRIPTPATH/data/siardsuite/siardgui.sh
if [ ! -f $SRC ]; then
    sudo -H -u $OWNER bash -c "cp $SRC $BINDIR/siardgui.sh";
fi

SRC=$SCRIPTPATH/img/siardsuite.png
FNAME=$PWCONFIGDIR/img/siardsuite.png
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $PWCONFIGDIR/img;";
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
fi

if [ ! -f $APPS/siardsuite.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/desktop/siardsuite.desktop $APPS;";
    sed -i "/Exec=dummy/c\Exec=$BINDIR/siardgui.sh" $APPS/siardsuite.desktop; 
    sed -i "/Icon=dummy/c\Icon=$FNAME" $APPS/siardsuite.desktop;   
    chown $OWNER:$OWNER $APPS/siardsuite.desktop;  
fi

cd $SCRIPTPATH;



