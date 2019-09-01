#!/bin/bash

apt-get remove -y xed;

TA_DIR="~/.textadept/.git/"
if [ ! -d "$TA_DIR" ]; then
    OWNER=$(stat -c '%U' ~);
    git clone https://github.com/BBATools/TextadeptSettings.git ~/.textadept/;
    chown -R $OWNER ~/.textadept/;
fi

xdg-mime default textadept.desktop text/english text/plain text/x-makefile text/x-c++hdr text/x-c++src text/x-chdr text/x-csrc text/x-java text/x-moc text/x-pascal text/x-tcl text/x-tex application/x-shellscript text/x-c text/x-c++
      


