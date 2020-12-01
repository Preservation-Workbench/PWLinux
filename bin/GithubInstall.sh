#!/bin/bash
isInFile=$(cat /etc/apt/sources.list.d/packagecloud-shiftky-desktop.list | grep -c "https://packagecloud.io/shiftkey/desktop/any/")
if [ $isInFile -eq 0 ]; then    
    wget -qO - https://packagecloud.io/shiftkey/desktop/gpgkey | sudo tee /etc/apt/trusted.gpg.d/shiftkey-desktop.asc > /dev/null
    echo 'deb [arch=amd64] https://packagecloud.io/shiftkey/desktop/any/ any main' > /etc/apt/sources.list.d/packagecloud-shiftky-desktop.list;
    apt-get update;
fi

apt-get install -y github-desktop;