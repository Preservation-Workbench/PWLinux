#!/bin/bash

apt remove -y hexchat-common hexchat thunderbird rhythmbox tomboy xplayer xfce4-taskmanager;

# snap install curl-simosx;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);
# TODO: Flytt deler av dette til PWBInstall.sh
sudo -H -u $OWNER bash -c "python3 -m pip install -U ttkthemes unoconv zenipy execsql pdfy autopep8 rope toposort petl execsql epc JPype1==0.6.3 jaydebeapi --user";

if [ $(dpkg-query -W -f='${Status}' ripgrep 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget -qO /tmp/ripgrep.deb https://github.com/BurntSushi/ripgrep/releases/download/11.0.2/ripgrep_11.0.2_amd64.deb;
    apt-get install -y /tmp/ripgrep.deb;
fi

if [ ! -f /home/$OWNER/bin/xsv ]; then
    sudo -H -u $OWNER bash -c "wget -qO /home/$OWNER/bin/xsv.tar.gz https://github.com/BurntSushi/xsv/releases/download/0.13.0/xsv-0.13.0-x86_64-unknown-linux-musl.tar.gz";
    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin && dtrx xsv.tar.gz && rm xsv.tar.gz";
fi

if [ ! -f /home/$OWNER/bin/csvcleaner ]; then
    sudo -H -u $OWNER bash -c "wget -qO /home/$OWNER/bin/datatools.zip https://github.com/caltechlibrary/datatools/releases/download/v0.0.25/datatools-v0.0.25-linux-amd64.zip";
    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin && dtrx datatools.zip && rm datatools.zip";
    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin/datatools/bin && cp * ../../ && rm -rdf /home/$OWNER/bin/datatools";
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

# TODO: xfce og ikke mate under?
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
sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.arkimint";

#Set Arkimint icon for whisker menu
sudo -H -u $OWNER bash -c "cp arkimint_fin_32px.png /home/$OWNER/.arkimint";
sudo -H -u $OWNER bash -c 'sed -i "s:^button-icon=.*:button-icon=/home/'"$OWNER"'/.arkimint/arkimint_fin_32px.png:g" ~/.config/xfce4/panel/whiskermenu-1.rc'
su $OWNER -m -c "xfce4-panel -r "

# Install virtualbox guest extensions if vb virtual machine
VIRT=$( dmidecode -s system-manufacturer )
if [ "$VIRT" == "innotek GmbH" ]; then #Virtualbox
    sudo usermod -aG vboxsf $OWNER;
    lsmod | grep vboxguest  || apt-get install -y build-essential dkms linux-headers-generic virtualbox-guest-dkms virtualbox-guest-utils virtualbox-guest-x11;
fi

#Hide user list from login screen
# TODO: Har ikke virket ved siste kjøring -> fiks
sed -i '/^greeter-hide-users=/{h;s/=.*/=true/};${x;/^$/{s//greeter-hide-users=true/;H};x}' /etc/lightdm/lightdm.conf

# Firefox
ff_prefs=/home/$OWNER/.mozilla/firefox/*.default-release/prefs.js
isInFile=$(cat $ff_prefs | grep -c 'startup.homepage", "')
if [ $isInFile -eq 0 ]; then
    sudo -H -u $OWNER bash -c "killall firefox"
    echo "user_pref(\"browser.startup.homepage\", \"https://www.google.com\");" >> $ff_prefs
    chown $OWNER:$OWNER $ff_prefs;
fi
