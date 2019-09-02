#!/bin/bash

OWNER=$(stat -c '%U' $PWD);
echo '#!/bin/bash
emacs --daemon' > /home/$OWNER/bin/emacs_daemon.sh

chmod a+rx /home/$OWNER/bin/emacs_daemon.sh;

echo "[Desktop Entry]
Type=Application
Exec=/home/$OWNER/bin/emacs_daemon.sh
Hidden=false
X-MATE-Autostart-enabled=true
Name=Emacs_Daemon" > /home/$OWNER/.config/autostart/Emacs_Daemon.desktop;

cat <<\EOF > /home/$OWNER/bin/amacs
#! /bin/bash -e
frame=`emacsclient -a '' -e "(member \"$DISPLAY\" (mapcar 'terminal-name (frames-on-display-list)))" 2>/dev/null`
[[ "$frame" == "nil" ]] && opts='-c' # if there is no frame open create one
[[ "${@/#-nw/}" == "$@" ]] && opts="$opts -n"
if [ -z "$@" ] ; then
	wmctrl -xa emacs || emacsclient -n -c
else
	exec emacsclient -a '' $opts "$@"
fi
wmctrl -xa emacs
EOF

chmod a+rx /home/$OWNER/bin/amacs;

if [ ! -f /home/$OWNER/.local/share/applications/emacs26.desktop ]; then
    cp /usr/share/applications/emacs26.desktop  /home/$OWNER/.local/share/applications;
    sed -i -e 's/emacs26 %F/amacs %F/' /home/$OWNER/.local/share/applications/emacs26.desktop;
fi

EMACS_DIR="~/.emacs.d/.git/"
if [ ! -d "$EMACS_DIR" ]; then
    git clone https://github.com/BBATools/Arkimacs.git ~/.emacs.d/;
    chown -R $OWNER ~/.emacs.d/;
fi

#xdg-mime default codium.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++


