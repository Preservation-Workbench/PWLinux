#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
cd $SCRIPTPATH;

if [ ! -f /tmp/microsoft.gpg ]; then
    cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
    install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg;
fi

isInFile=$(cat /etc/apt/sources.list.d/vscode.list | grep -c "https://packages.microsoft.com/repos/vscode")
if [ $isInFile -eq 0 ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/vscode stable main" > /etc/apt/sources.list.d/vscode.list;
fi

apt-get update;
apt-get install -y code;

sudo -H -u $OWNER bash -c "code --install-extension smlombardi.soho; \
code --install-extension fabiospampinato.vscode-highlight; \
code --install-extension ms-python.python;";

REPOSRC="https://github.com/Preservation-Workbench/vscode_config.git"
LOCALREPO="/home/$OWNER/.config/Code/User"
sudo -H -u $OWNER bash -c "git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull"
cd $SCRIPTPATH;
# TODO: Legg til som pinned i xfce dock

#xdg-mime default code.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++

