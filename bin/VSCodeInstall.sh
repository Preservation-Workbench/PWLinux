#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

isInFile=$(cat /etc/apt/sources.list | grep -c "https://packages.microsoft.com/repos/vscode")
if [ $isInFile -eq 0 ]; then
    apt-get install -y software-properties-common apt-transport-https wget;
    cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
    install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg;
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list;
    apt-get update;
fi

apt-get install -y code;



# sudo -H -u $OWNER bash -c "codium --install-extension smlombardi.soho; \
# codium --install-extension fabiospampinato.vscode-highlight; \
# codium --install-extension ms-python.python;";

# REPOSRC="https://github.com/BBATools/VSCodiumSettings.git"
# LOCALREPO="/home/$OWNER/.config/VSCodium/User"
# sudo -H -u $OWNER bash -c "git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull"

#xdg-mime default codium.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++


