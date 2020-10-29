#!/bin/bash

isInFile=$(cat /etc/apt/sources.list.d/kelleyk-emacs-focal.list | grep -c "http://ppa.launchpad.net/kelleyk/emacs/ubuntu")
if [ $isInFile -eq 0 ]; then
    curl -sSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x873503a090750cdaeb0754d93ff0e01eeaafc9cd' | apt-key add -;
    echo "deb http://ppa.launchpad.net/kelleyk/emacs/ubuntu focal main" > /etc/apt/sources.list.d/kelleyk-emacs-focal.list;
fi

apt-get update;
apt-get install -y emacs27 libvterm-dev libtool-bin cmake;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

# WAIT: Legg inn sjekk og beskjed hvis emacs installert men ikke doom variant
REPOSRC="https://github.com/hlissner/doom-emacs"
LOCALREPO="/home/$OWNER/.emacs.d"
if [ ! -f "$LOCALREPO"/bin/doom ]; then
    sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" && "$LOCALREPO"/bin/doom install;";
fi    

REPOSRC="https://github.com/Preservation-Workbench/PWEmacs"
LOCALREPO="/home/$OWNER/.doom.d"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull;";
sudo -H -u $OWNER bash -c ""$LOCALREPO"/bin/doom sync;";



# echo '#!/bin/bash
# emacs --daemon' > /home/$OWNER/bin/emacs_daemon.sh;
# chmod a+rx /home/$OWNER/bin/emacs_daemon.sh;
# chown $OWNER:$OWNER /home/$OWNER/bin/emacs_daemon.sh;

# echo "[Desktop Entry]
# Type=Application
# Exec=/home/$OWNER/bin/emacs_daemon.sh
# Hidden=false
# X-MATE-Autostart-enabled=true
# Name=Emacs_Daemon" > /home/$OWNER/.config/autostart/Emacs_Daemon.desktop;
# chown $OWNER:$OWNER /home/$OWNER/.config/autostart/Emacs_Daemon.desktop;

# cat <<\EOF > /home/$OWNER/bin/amacs
# #! /bin/bash -e
# frame=`emacsclient -a '' -e "(member \"$DISPLAY\" (mapcar 'terminal-name (frames-on-display-list)))" 2>/dev/null`
# [[ "$frame" == "nil" ]] && opts='-c' # if there is no frame open create one
# [[ "${@/#-nw/}" == "$@" ]] && opts="$opts -n"
# if [ -z "$@" ] ; then
# 	wmctrl -xa emacs || emacsclient -n -c
# else
# 	exec emacsclient -a '' $opts "$@"
# fi
# wmctrl -xa emacs
# EOF

# chmod a+rx /home/$OWNER/bin/amacs;
# chown $OWNER:$OWNER /home/$OWNER/bin/amacs;

# if [ ! -f /home/$OWNER/.local/share/applications/emacs26.desktop ]; then
#     cp /usr/share/applications/emacs26.desktop  /home/$OWNER/.local/share/applications;
#     sed -i -e 's/emacs26 %F/amacs %F/' /home/$OWNER/.local/share/applications/emacs26.desktop;
#     chown $OWNER:$OWNER /home/$OWNER/.local/share/applications/emacs26.desktop;
# fi

# REPOSRC="https://github.com/BBATools/Arkimacs.git"
# LOCALREPO="/home/$OWNER/.emacs.d"
# sudo -H -u $OWNER bash -c "git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull"

# #xdg-mime default codium.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++


