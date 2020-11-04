#!/bin/bash

isInFile=$(cat /etc/apt/sources.list | grep -c "https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-ubuntu2004")
if [ $isInFile -eq 0 ]; then    
    apt-get install apt-transport-https ca-certificates; #Needed for all https repos    
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
sudo apt-get install siegfried;


# apt remove -y hexchat-common hexchat rhythmbox tomboy xplayer xfce4-taskmanager;


SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

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
SRC=$SCRIPTPATH/img/pwlinux.png
FNAME="/home/$OWNER/.local/share/wallpapers/pwlinux.png"
if [ ! -f $FNAME ]; then
    sudo -H -u $OWNER bash -c "cp $SRC $FNAME"
fi
USR_ID=$( id -u $OWNER )
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$USR_ID/bus
su $OWNER -m -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitor0/workspace0/last-image -s $FNAME"
su $OWNER -m -c "xfconf-query -c xfce4-desktop -p /backdrop/screen0/monitorVirtual1/workspace0/last-image -s $FNAME"

# #TODO: Bruk mappe under fra PWB for å sjekke om er på Arkimint eller ikke
# sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.arkimint";

# #Set Arkimint icon for whisker menu
# sudo -H -u $OWNER bash -c "cp arkimint_fin_32px.png /home/$OWNER/.arkimint";
# sudo -H -u $OWNER bash -c 'sed -i "s:^button-icon=.*:button-icon=/home/'"$OWNER"'/.arkimint/arkimint_fin_32px.png:g" ~/.config/xfce4/panel/whiskermenu-1.rc'
# su $OWNER -m -c "xfce4-panel -r "

# #Hide user list from login screen
# # TODO: Har ikke virket ved siste kjøring -> fiks
# sed -i '/^greeter-hide-users=/{h;s/=.*/=true/};${x;/^$/{s//greeter-hide-users=true/;H};x}' /etc/lightdm/lightdm.conf

# # Firefox
# ff_prefs=/home/$OWNER/.mozilla/firefox/*.default-release/prefs.js
# isInFile=$(cat $ff_prefs | grep -c 'startup.homepage", "')
# if [ $isInFile -eq 0 ]; then
#     sudo -H -u $OWNER bash -c "killall firefox"
#     echo "user_pref(\"browser.startup.homepage\", \"https://www.google.com\");" >> $ff_prefs
#     chown $OWNER:$OWNER $ff_prefs;
# fi
