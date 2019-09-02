#!/bin/bash
OWNER=$(stat -c '%U' $PWD);

sudo -H -u $OWNER bash -c 'codium --install-extension smlombardi.soho';
sudo -H -u $OWNER bash -c 'codium --install-extension fabiospampinato.vscode-highlight';
sudo -H -u $OWNER bash -c 'codium --install-extension ms-python.python';

VS_DIR="~/.config/VSCodium/User/.git/"
if [ ! -d "$VS_DIR" ]; then
    git clone https://github.com/BBATools/VSCodiumSettings.git ~/.config/VSCodium/User/;
    chown -R $OWNER ~/.config/VSCodium/User/;
fi

#xdg-mime default codium.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++


