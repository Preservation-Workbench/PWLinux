#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

sudo -H -u $OWNER bash -c "codium --install-extension smlombardi.soho; \
codium --install-extension fabiospampinato.vscode-highlight; \
codium --install-extension ms-python.python;";

REPOSRC="https://github.com/BBATools/VSCodiumSettings.git"
LOCALREPO="/home/$OWNER/.config/VSCodium/User"
sudo -H -u $OWNER bash -c "git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull"

#xdg-mime default codium.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++


