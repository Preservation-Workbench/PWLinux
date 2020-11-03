#!/bin/bash

isInFile=$(cat /etc/apt/sources.list.d/kelleyk-emacs-focal.list | grep -c "http://ppa.launchpad.net/kelleyk/emacs/ubuntu")
if [ $isInFile -eq 0 ]; then
    curl -sSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x873503a090750cdaeb0754d93ff0e01eeaafc9cd' | apt-key add -;
    echo "deb http://ppa.launchpad.net/kelleyk/emacs/ubuntu focal main" > /etc/apt/sources.list.d/kelleyk-emacs-focal.list;
fi

apt-get update;
apt-get install -y emacs27 git libvterm-dev libtool-bin cmake ripgrep hunspell-no hunspell fzf fd-find universal-ctags python3-pip;

# WAIT: Lag config for xkeysnail og start auto med emacs eller ved login
pip3 install xkeysnail -U;
if [ ! -f "/etc/sudoers.d/xkeysnail" ]; then
    echo "$USER ALL = (root) NOPASSWD: /usr/local/bin/xkeysnail" | tee /etc/sudoers.d/xkeysnail;
    chmod 0440 /etc/sudoers.d/xkeysnail;
fi    

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH);

# WAIT: Legg inn sjekk og beskjed hvis emacs installert men ikke doom variant
REPOSRC="https://github.com/hlissner/doom-emacs"
EMACSREPO="/home/$OWNER/.emacs.d"
if [ ! -f "$EMACSREPO"/bin/doom ]; then
    sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$EMACSREPO";";
    sudo -H -u $OWNER bash -c ""$EMACSREPO"/bin/doom -y install --no-config --no-env --no-fonts;";
    sudo -H -u $OWNER bash -c ""$EMACSREPO"/bin/doom env;";
fi    

REPOSRC="https://github.com/Preservation-Workbench/PWEmacs"
DOOMREPO="/home/$OWNER/.doom.d"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$DOOMREPO" 2> /dev/null || git -C "$DOOMREPO" pull;";

FONTDIR="/home/$OWNER/.local/share/fonts"
if [ ! -f $FONTDIR/all-the-icons.ttf ]; then
    sudo -H -u $OWNER bash -c "cd /tmp/ && git clone --depth 1 https://github.com/domtronn/all-the-icons.el.git;";
    sudo -H -u $OWNER bash -c "mkdir -p $FONTDIR;"; 
    sudo -H -u $OWNER bash -c "cp /tmp/all-the-icons.el/fonts/* $FONTDIR;";   
    sudo -H -u $OWNER bash -c "fc-cache -f -v;";   
fi

sudo -H -u $OWNER bash -c ""$EMACSREPO"/bin/doom sync;";

if [ ! -f /home/$OWNER/.local/share/applications/emacs27.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.local/share/applications;";  
    sudo -H -u $OWNER bash -c "cp /usr/share/applications/emacs27.desktop /home/$OWNER/.local/share/applications/;"; 
    sed -i '/Exec=emacs/c\Exec=sh -c "emacsclient -a emacs -n \"\$@\" || emacs" dummy %F' /home/$OWNER/.local/share/applications/emacs27.desktop;
    chown $OWNER:$OWNER /home/$OWNER/.local/share/applications/emacs27.desktop;
fi   

isInFile=$(cat /home/$OWNER/.bashrc | grep -c "emacs()")
if [ $isInFile -eq 0 ]; then
    sudo -H -u $OWNER bash -c "echo "" >> /home/$OWNER/.bashrc;";
    sudo -H -u $OWNER bash -c "echo 'emacs() { emacsclient -a \"emacs\" -n \"\$@\" 2>/dev/null || command emacs & disown; }' >> /home/$OWNER/.bashrc";
fi    

# #xdg-mime default emacs27.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++
