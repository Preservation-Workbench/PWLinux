#!/bin/bash

apt remove -y hexchat-common hexchat thunderbird rhythmbox tomboy xplayer xfce4-taskmanager;

#pip3 install -U autopep8 --user
#python3 -m pip install -U rope --user

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
sudo -H -u $OWNER bash -c "python3 -m pip install -U ttkthemes unoconv zenipy execsql epc --user";

if [ $(dpkg-query -W -f='${Status}' ripgrep 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget -qO /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb;
    apt-get install -y /tmp/ripgrep.deb;
fi

cat <<\EOF > /home/$OWNER/bin/div_fix.sh
#! /bin/bash
pkill gvfsd-fuse && /usr/lib/gvfs/gvfsd-fuse -o allow_other /var/run/user/1000/gvfs/
setxkbmap -option 'numpad:microsoft'
#"$ORACLE_HOME"/bin/lsnrctl start && sudo /etc/init.d/oracle-xe start
if [ -f /etc/init.d/oracle-xe ]; then
    #/u01/app/oracle/product/11.2.0/xe/config/scripts/startdb.sh;
    sudo /etc/init.d/oracle-xe start;
fi
EOF
chmod a+rx /home/$OWNER/bin/div_fix.sh
chown $OWNER:$OWNER /home/$OWNER/bin/div_fix.sh;

echo "[Desktop Entry]
Type=Application
Exec=/home/$OWNER/bin/div_fix.sh
Hidden=false
X-MATE-Autostart-enabled=true
Name=Div_Fix" > /home/$OWNER/.config/autostart/Div_Fix.desktop;
chown $OWNER:$OWNER /home/$OWNER/.config/autostart/Div_Fix.desktop;

# Set wallpaper
sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.local/share/wallpapers"
SRC_URI="https://raw.githubusercontent.com/Nitrux/luv-icon-theme/master/Wallpapers/Night/contents/images/2560x1080.png"
FNAME="/home/$OWNER/.local/share/wallpapers/arkimint.png"
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "wget $SRC_URI -O $FNAME"
fi
USR_ID=$( id -u $OWNER )
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USR_ID/bus
su $OWNER -m -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s $FNAME"

#TODO: Bruk mappe under fra PWB for å sjekke om er på Arkimint eller ikke
sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.arkimint"

#TODO: Legg inn sjekk på om guest extensions allerede er installert
VIRT=$( dmidecode -s system-manufacturer )
if [ "$VIRT" == "innotek GmbH" ]; then #Virtualbox
    sudo usermod -aG vboxsf $OWNER;
    apt-get install -y build-essential dkms linux-headers-generic virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11;
fi


