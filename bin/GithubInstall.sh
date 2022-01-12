#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
APPS=/home/$OWNER/.local/share/applications

# isInFile=$(cat /etc/apt/sources.list.d/packagecloud-shiftky-desktop.list | grep -c "https://packagecloud.io/shiftkey/desktop/any/")
# if [ $isInFile -eq 0 ]; then    
#     wget -qO - https://packagecloud.io/shiftkey/desktop/gpgkey | sudo tee /etc/apt/trusted.gpg.d/shiftkey-desktop.asc > /dev/null
#     echo 'deb [arch=amd64] https://packagecloud.io/shiftkey/desktop/any/ any main' > /etc/apt/sources.list.d/packagecloud-shiftky-desktop.list;
#     apt-get update;
# fi

# apt-get install -y github-desktop;

# if [ ! -f $APPS/github-desktop.desktop ]; then
#     sudo -H -u $OWNER bash -c "mkdir -p $APPS;";
#     sudo -H -u $OWNER bash -c "cp /usr/share/applications/github-desktop.desktop $APPS;";
#     sed -i "/Categories=/c\Categories=Development;" $APPS/github-desktop.desktop;   
#     chown $OWNER:$OWNER $APPS/github-desktop.desktop;      
# fi

# WMCLASS="StartupWMClass=GitHub Desktop"
# isInFile=$(cat $APPS/github-desktop.desktop | grep -c "$WMCLASS")
# if [ $isInFile -eq 0 ]; then 
#     sudo -H -u $OWNER bash -c "echo $WMCLASS >> $APPS/github-desktop.desktop;";
# fi

flatpak install -y --noninteractive flathub io.github.shiftey.Desktop;

cd $SCRIPTPATH;