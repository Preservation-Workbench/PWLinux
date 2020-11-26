#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
PWCONFIGDIR=/home/$OWNER/.config/pwlinux
USERID=$(id -u $OWNER)
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USERID/bus";

sudo add-apt-repository -y ppa:diesch/stable;
apt-get update;
mintupdate-cli -y --keep-configuration upgrade;
echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | sudo debconf-set-selections;

# WAIT: Flytt noen av pakkene under til delscript. Noen bør også kunne fjernes
apt-get install -y git ttf-mscorefonts-installer mint-meta-codecs exfat-fuse xfce4-fsguard-plugin exfat-utils hunspell hunspell-no rar flatpak pandoc \
soundconverter openoffice.org-hyphenation openjfx npm sqlite3 python3-virtualenv python3-setuptools uchardet libtool-bin meld mercurial python3-dev \
checkinstall xchm subversion dos2unix apt-transport-https ca-certificates xfpanel-switch thunar-vcs-plugin thunar-gtkhash gnome-system-monitor python3-wheel \
python3-pip build-essential dos2unix ghostscript icc-profiles-free liblept5 libxml2 xul-ext-lightning thunderbird-locale-en clamtk tesseract-ocr clamav-daemon \
clamav-unofficial-sigs clamdscan libclamunrar9 pngquant hyphen-fi hyphen-ga hyphen-id arronax birdtray wimtools wkhtmltopdf abiword imagemagick \
python3-pgmagick graphicsmagick graphviz openjdk-11-jdk img2pdf;

systemctl enable clamav-daemon;
systemctl start clamav-daemon;

# TODO: Kopier mintwelcome.desktop til /home/pwb/.local/share/applications/ og endre med sed så ikke synlig

sed -i -e 's/#user_allow_other/user_allow_other/' /etc/fuse.conf;

if [ -f "/etc/ImageMagick-6/policy.xml" ]; then
    mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xmlout  2>/dev/null;
fi

# WAIT: Flytt dette nederst?
apt-get autoremove -y;
apt-get remove -y --purge `dpkg -l | grep '^rc' | awk '{print $2}'` #Remove residual config
flatpak uninstall -y --unused;

isInFile=$(cat /etc/apt/sources.list.d/home-ungoogled_chromium.list | grep -c "http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/")
if [ $isInFile -eq 0 ]; then    
    wget -qO - https://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/Release.key | sudo apt-key add - 
    echo 'deb http://download.opensuse.org/repositories/home:/ungoogled_chromium/Ubuntu_Focal/ /' > /etc/apt/sources.list.d/home-ungoogled_chromium.list;
    killall firefox;
    apt remove -y hexchat-common hexchat rhythmbox xfce4-taskmanager firefox timeshift;    
    flatpak install -y --noninteractive flathub org.mozilla.firefox;
fi

apt-get update;
apt-get install -y ungoogled-chromium;
sudo -H -u $OWNER bash -c "xdg-settings set default-web-browser chromium.desktop";


isInFile=$(cat /etc/apt/sources.list | grep -c "https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-ubuntu2004")
if [ $isInFile -eq 0 ]; then    
    apt-get install -y apt-transport-https ca-certificates; #Needed for all https repos  
    wget -O /tmp/repomd.xml.key https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-centos7/repodata/repomd.xml.key && apt-key add /tmp/repomd.xml.key;
    echo 'deb https://www.collaboraoffice.com/repos/CollaboraOnline/CODE-ubuntu2004 ./' >> /etc/apt/sources.list;
    cd $SCRIPTPATH;
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

# Set wallpaper:
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

# WAIT: Bruk mappe under fra PWCode for å sjekke om er på PWLinux eller ikke
sudo -H -u $OWNER bash -c "mkdir -p $PWCONFIGDIR/img";

# Set menu icon and theme:
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

# Install Oracle:
source $SCRIPTPATH/OracleInstall.sh
isInFile=$(cat /etc/lightdm/lightdm.conf | grep -c "greeter-hide-users=true")
if [ $isInFile -eq 0 ]; then
    echo 'greeter-hide-users=true' >> /etc/lightdm/lightdm.conf; #Hide oracle user
fi

# Install MSSQL:
source $SCRIPTPATH/MSSQLInstall.sh

# Install MySQL:
source $SCRIPTPATH/MySQLInstall.sh

# Install URD:
source $SCRIPTPATH/URDInstall.sh

# Install PostgreSQL:
source $SCRIPTPATH/PostgreSQLInstall.sh

# Install OnlyOffice:
source $SCRIPTPATH/OnlyofficeInstall.sh

# Install DBeaver:
source $SCRIPTPATH/DBeaverInstall.sh

# Install VSCode:
source $SCRIPTPATH/VSCodeInstall.sh

# Install VSCode:
source $SCRIPTPATH/TikaInstall.sh

# Install VSCode:
source $SCRIPTPATH/PWCodeInstall.sh

# Install pwb service menu:
SREPO="https://github.com/Preservation-Workbench/pwb_service_menu"
LREPO="/home/$OWNER/bin/gui/pwb_service_menu"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$SREPO" "$LREPO" 2> \
    /dev/null || git -C "$LREPO" pull;";

# Autostart pwb service menu:
$CMD="python3 ~/bin/gui/pwb_service_menu/tray_menu.py & disown"
isInFile=$(cat /home/$OWNER/.profile | grep -c $CMD)
if [ $isInFile -eq 0 ]; then
    sudo -H -u $OWNER bash -c "echo "" >> /home/$OWNER/.profile;";
    sudo -H -u $OWNER bash -c "echo $CMD >> /home/$OWNER/.profile";
fi


# Configure Xfce panel:
sudo add-apt-repository -y ppa:xubuntu-dev/extras;
sudo apt-get update;
apt-get install -y xfce4-docklike-plugin;

su $OWNER -m -c "cat <<\EOF > /home/$OWNER/.config/xfce4/panel/docklike-100.rc
[user]
pinned=/usr/share/applications/xfce4-terminal.desktop;/usr/share/applications/gnome-system-monitor.desktop;/home/pwb/.local/share/applications/emacs27.desktop;/usr/share/applications/thunar.desktop;/usr/share/applications/chromium.desktop;/home/pwb/.local/share/applications/PWCode.desktop;/usr/share/applications/org.xfce.Catfish.desktop;/home/pwb/.local/share/applications/SQLWB.desktop;/usr/share/applications/dbeaver.desktop;/usr/share/applications/code.desktop;/usr/share/applications/clamtk.desktop;
EOF
"

su $OWNER -m -c "cat <<\EOF > /home/$OWNER/.config/xfce4/panel/fsguard-101.rc
yellow=8
red=2
lab_size_visible=false
progress_bar_visible=false
hide_button=false
label=
label_visible=false
mnt=/
EOF
"

sudo -H -u $OWNER bash -c "rm -rdf /home/$OWNER/.config/xfce4/panel/launcher*"
su $OWNER -m -c "xfconf-query -c xfce4-panel -pn "/plugins/plugin-100" -t string -s 'docklike'"
su $OWNER -m -c "xfconf-query -c xfce4-panel -pn "/plugins/plugin-101" -t string -s 'fsguard'"
su $OWNER -m -c "xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -n -a -t int -s 1 -t int -s 2 -t int -s 100 -t int -s 7 -t int -s 101 -t int -s 8 -t int -s 9 -t int -s 10 -t int -s 11 -t int -s 12 -t int -s 13"
su $OWNER -m -c "xfconf-query --channel 'xfce4-panel' --property '/panels/panel-1/size' --type int --set 40"
su $OWNER -m -c "xfce4-panel -r "

# Fix numpad
isInFile=$(cat /home/$OWNER/.profile | grep -c "setxkbmap -option numpad:microsoft")
if [ $isInFile -eq 0 ]; then
    sudo -H -u $OWNER bash -c "echo "" >> /home/$OWNER/.profile;";
    sudo -H -u $OWNER bash -c "echo 'setxkbmap -option numpad:microsoft' >> /home/$OWNER/.profile";
fi


