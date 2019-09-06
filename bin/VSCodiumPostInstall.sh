#!/bin/bash
SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

sudo -H -u $OWNER bash -c "codium --install-extension smlombardi.soho; \
codium --install-extension fabiospampinato.vscode-highlight; \
codium --install-extension ms-python.python;";

VS_DIR="/home/$OWNER/.config/VSCodium/User"
sudo -H -u $OWNER bash -c "git clone --no-checkout https://github.com/BBATools/VSCodiumSettings.git $VS_DIR/tmp; \
mv $VS_DIR/tmp/.git $VS_DIR; \
rmdir $VS_DIR/tmp; \
cd $VS_DIR && git reset --hard HEAD;";

#xdg-mime default codium.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++


