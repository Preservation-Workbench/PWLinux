#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

# TODO: Legg inn default xresources fil

# url="https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x873503a090750cda\
#     eb0754d93ff0e01eeaafc9cd"
# url=$(echo $url | tr -d ' ')
# echo $url
# isInFile=$(cat /etc/apt/sources.list.d/kelleyk-emacs-focal.list | grep -c \
#     "http://ppa.launchpad.net/kelleyk/emacs/ubuntu")
# if [ $isInFile -eq 0 ]; then
#     curl -sSL "$url" | apt-key add -;
#     echo "deb http://ppa.launchpad.net/kelleyk/emacs/ubuntu focal main"\
#         > /etc/apt/sources.list.d/kelleyk-emacs-focal.list;
# fi

if [ $(dpkg-query -W -f='${Status}' emacs-ng 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    apt-get install -y libncurses5 libgccjit0 libjpeg9;  
    cd /tmp/ && wget -c https://github.com/emacs-ng/emacs-ng/releases/download/v0.0.4884a6e/emacs-ng_0.0.4884a6e_amd64.deb
    sudo DEBIAN_FRONTEND=noninteractive dpkg --install emacs-ng_0.0.4884a6e_amd64.deb
fi 

apt-get update;
apt-get install -y emacs28 git libvterm-dev libtool-bin cmake ripgrep \
    hunspell-no hunspell universal-ctags python3-bashate black \
    jq clang-format pipenv python3-pytest shellcheck node-js-beautify \
    fonts-firacode direnv grip;

# WAIT: Legg inn sjekk og beskjed hvis emacs installert men ikke doom variant
REPOSRC="https://github.com/hlissner/doom-emacs"
EMACSREPO="/home/$OWNER/.emacs.d"
if [ ! -f "$EMACSREPO"/bin/doom ]; then
    sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$EMACSREPO";";
    sudo -H -u $OWNER bash -c ""$EMACSREPO"/bin/doom -y install --no-config \
        --no-env --no-fonts;";
    sudo -H -u $OWNER bash -c ""$EMACSREPO"/bin/doom env;";
fi

REPOSRC="https://github.com/Preservation-Workbench/PWEmacs"
DOOMREPO="/home/$OWNER/.doom.d"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$DOOMREPO" 2> \
    /dev/null || git -C "$DOOMREPO" pull;";

FONTDIR="/home/$OWNER/.local/share/fonts"
if [ ! -f $FONTDIR/all-the-icons.ttf ]; then
    sudo -H -u $OWNER bash -c "git clone --depth 1 \
        https://github.com/domtronn/all-the-icons.el.git /tmp/all-the-icons.el;";
    sudo -H -u $OWNER bash -c "mkdir -p $FONTDIR;";
    sudo -H -u $OWNER bash -c "cp /tmp/all-the-icons.el/fonts/* $FONTDIR;";
    sudo -H -u $OWNER bash -c "fc-cache -f -v;";
fi

sudo -H -u $OWNER bash -c ""$EMACSREPO"/bin/doom sync;";

if [ ! -f /home/$OWNER/.local/share/applications/emacs28.desktop ]; then
    sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.local/share/applications;";
    sudo -H -u $OWNER bash -c "cp /usr/share/applications/emacs28.desktop \
    /home/$OWNER/.local/share/applications/;";
    sed -i \
        '/Exec=emacs/c\Exec=sh -c "emacsclient -a emacs -n \"\$@\" || emacs" dummy %F'\
        /home/$OWNER/.local/share/applications/emacs28.desktop;  
    chown $OWNER:$OWNER /home/$OWNER/.local/share/applications/emacs28.desktop;
fi

isInFile=$(cat /home/$OWNER/.bashrc | grep -c "emacs()")
if [ $isInFile -eq 0 ]; then
    sudo -H -u $OWNER bash -c "echo "" >> /home/$OWNER/.bashrc;";
    sudo -H -u $OWNER bash -c \
        "echo 'emacs() { emacsclient -a \"emacs\" -n \"\$@\" 2>/dev/null || command emacs & disown; }'\
        >> /home/$OWNER/.bashrc";
fi

cd $SCRIPTPATH;

# #xdg-mime default emacs28.desktop text/english text/plain text/x-makefile \
# text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc \
# text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c \
# text/x-c++
