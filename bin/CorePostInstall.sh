#!/bin/bash
killall synaptic

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
USERID=$(id -u $OWNER)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USERID/bus"

isInFile=$(cat /etc/apt/sources.list | grep -c "https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-ubuntu2004")
if [ $isInFile -eq 0 ]; then    
    apt-get install -y apt-transport-https ca-certificates; #Needed for all https repos    
    cd /tmp/ && wget https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7/repodata/repomd.xml.key && apt-key add repomd.xml.key;
    echo 'deb https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-ubuntu2004 ./' >> /etc/apt/sources.list;
fi

apt-get update;
apt-get install -y loolwsd code-brand;
loolconfig set ssl.enable false;
loolconfig set ssl.termination true;
systemctl enable loolwsd;    
systemctl restart loolwsd;  
# Test: curl --insecure -F "data=@test.docx" http://localhost:9980/lool/convert-to/pdf > out.pdf


isInFile=$(cat /etc/apt/sources.list | grep -c "http://dl.bintray.com/siegfried/debian")
if [ $isInFile -eq 0 ]; then  
    wget -qO - https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add -;
    echo "deb http://dl.bintray.com/siegfried/debian wheezy main" | tee -a /etc/apt/sources.list;
fi    

sudo apt-get update;
sudo apt-get install -y siegfried;


# apt remove -y hexchat-common hexchat rhythmbox tomboy xplayer xfce4-taskmanager;
# TODO: Fjern firefox og fjern så /home/pwb/.config/xfce4/panel/launcher-3/ og så xfce4-panel -r  -> blir liggende igjen tom da :(



# TODO: Test uten div-fiks først. Ikke sikkert trenger alt. Evt. sette noen i bashrc el heller
# cat <<\EOF > /home/$OWNER/bin/div_fix.sh
# #! /bin/bash
# pkill gvfsd-fuse && /usr/lib/gvfs/gvfsd-fuse -o allow_other /var/run/user/1000/gvfs/
# setxkbmap -option 'numpad:microsoft'
# #"$ORACLE_HOME"/bin/lsnrctl start && sudo /etc/init.d/oracle-xe start
# if [ -f /etc/init.d/oracle-xe ]; then
#     #/u01/app/oracle/product/11.2.0/xe/config/scripts/startdb.sh;
#     sudo /etc/init.d/oracle-xe start;
# fi
# EOF
# chmod a+rx /home/$OWNER/bin/div_fix.sh
# chown $OWNER:$OWNER /home/$OWNER/bin/div_fix.sh;

# # TODO: xfce og ikke mate under?
# echo "[Desktop Entry]
# Type=Application
# Exec=/home/$OWNER/bin/div_fix.sh
# Hidden=false
# X-MATE-Autostart-enabled=true
# Name=Div_Fix" > /home/$OWNER/.config/autostart/Div_Fix.desktop;
# chown $OWNER:$OWNER /home/$OWNER/.config/autostart/Div_Fix.desktop;

# # Set wallpaper
sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.local/share/wallpapers"
SRC=$SCRIPTPATH/img/pwlinux_wallpaper.png
FNAME="/home/$OWNER/.local/share/wallpapers/pwlinux_wallpaper.png"
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
    USR_ID=$( id -u $OWNER )
    export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USR_ID/bus
    su $OWNER -m -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s $FNAME"
    su $OWNER -m -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s $FNAME"    
fi

# #WAIT: Bruk mappe under fra PWCode for å sjekke om er på PWLinux eller ikke
sudo -H -u $OWNER bash -c "mkdir -p $PWCONFIGDIR/img";

# #Set menu icon and theme
sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.local/share/themes"
SRC=$SCRIPTPATH/img/pwlinux_icon.png
FNAME="$PWCONFIGDIR/img/pwlinux_icon.png"
if [ ! -f $FNAME ]; then
    sudo apt-get update;
    sudo apt-get install -y papirus-icon-theme;
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
    sudo -H -u $OWNER bash -c 'sed -i "s:^button-icon=.*:button-icon='"$PWCONFIGDIR"'/img/pwlinux_icon.png:g" ~/.config/xfce4/panel/whiskermenu-1.rc'
    su $OWNER -m -c "xfconf-query -c xsettings -p /Net/IconThemeName -s 'Papirus'"
    su $OWNER -m -c "xfconf-query -c xsettings -p /Net/ThemeName -s 'Mint-Y-Aqua'"
    su $OWNER -m -c "xfconf-query -c xfwm4 -p /general/theme -s 'Mint-Y-Red'"
    su $OWNER -m -c "xfce4-panel -r "
fi

# Install Emacs:
source $SCRIPTPATH/EmacsInstall.sh
LAUNCHD="/home/$OWNER/.config/xfce4/panel/launcher-100"
LAUNCHF="emacs27.desktop"
LAUNCHP="/home/$OWNER/.local/share/applications/$LAUNCHF"
sudo -H -u $OWNER bash -c "mkdir -p $LAUNCHD"
sudo -H -u $OWNER bash -c "cp $LAUNCHP $LAUNCHD"
su $OWNER -m -c "xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -a -t int -s 1 -t int -s 2 -t int -s 3 -t int -s 4 -t int -s 5 -t int -s 100 -t int -s 6 -t int -s 7 -t int -s 8 -t int -s 9 -t int -s 10 -t int -s 11 -t int -s 12 -t int -s 13"
su $OWNER -m -c "xfconf-query -c xfce4-panel -p /plugins/plugin-100 -n -t string -s launcher"
su $OWNER -m -c "xfconf-query -c xfce4-panel -p /plugins/plugin-100/items -n -a -t string -s $LAUNCHF"
su $OWNER -m -c "xfce4-panel -r "

# Install Oracle:
source $SCRIPTPATH/OracleInstall.sh
isInFile=$(cat /etc/lightdm/lightdm.conf | grep -c "greeter-hide-users=true")
if [ $isInFile -eq 0 ]; then    
    echo 'greeter-hide-users=true' >> /etc/lightdm/lightdm.conf; #Hide oracle user
fi

# Install MSSQL:
# TODO: Test MSSQL PÅ nytt om noen dager. Feil i deres repo
# source $SCRIPTPATH/MSSQLInstall.sh

