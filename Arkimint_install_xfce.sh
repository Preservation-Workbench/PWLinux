#!/bin/bash

#Mint xfce 19.1
# TODO: gjør google til std search engine i firefox + endre startside i firefox -> script senere
# TODO: Endret proxy via gui (gjør med script senere)
# TODO: Endre til kun ett workspace i fxce -> script senere

# TODO:
# git config --global user.email "mortenee@gmail.com"
# git config --global user.name "mortenee"


#USER:
#----------------------------- når VM ----------------------------------------------
sudo usermod -aG vboxsf $USER
sudo usermod -aG docker $USER
l
sudo add-apt-repository "deb http://ppa.launchpad.net/kelleyk/emacs/ubuntu bionic main"
#-------------
sudo apt-key adv --keyserver-options http-proxy=http://85.19.187.24:8080 --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C781C4A395E4009DF8D5DF0AA03A097E3C3842E1
sudo add-apt-repository "deb http://ppa.launchpad.net/x4121/ripgrep/ubuntu bionic main"
#-------------
sudo apt-key adv --keyserver-options http-proxy=http://85.19.187.24:8080 --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F3503FFDFA132F65E151D87CDCDE74FDB4591784
sudo add-apt-repository "deb http://ppa.launchpad.net/sandromani/gimagereader/ubuntu bionic main"
#----------------------------- uten proxy ----------------------------------------------
sudo add-apt-repository -y ppa:kelleyk/emacs
sudo add-apt-repository -y ppa:x4121/ripgrep
sudo add-apt-repository -y ppa:sandromani/gimagereader
#----------------------------- alle ----------------------------------------------
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"
#-------------
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo apt-key add -
# TODO: Endre repo i linje under når tilgjengelig for 18.04
sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/16.04/mssql-server-preview.list)"
#-------------
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'
#-------------
wget -qO - https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg | sudo apt-key add -
echo 'deb https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/repos/debs/ vscodium main' | sudo tee --append /etc/apt/sources.list

#DEFAULT APT PACKAGES:
sudo apt remove -y hexchat-common hexchat thunderbird rhythmbox tomboy xplayer xfce4-taskmanager openjdk-11*
sudo apt update
sudo apt upgrade -y
sudo sh -c "echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections"
sudo apt install -y git openjdk-8-jdk ttf-mscorefonts-installer python3-pandas mint-meta-codecs galternatives xchm regexxer subversion python3-pip \
build-essential graphviz dos2unix openjfx npm chm2pdf python3-setuptools meld mercurial python3-dev checkinstall ripgrep emacs26 sshfs mssql-server postgresql-11 \
apt-transport-https ca-certificates software-properties-common python3-tk docker-ce docker-compose python3-wheel yad nfoview gimagereader pylint3 flake8 vscodium xcape \
python-autopep8 freeglut3-dev libgstreamer-plugins-base1.0-dev python3-pyparsing xfpanel-switch thunar-vcs-plugin thunar-gtkhash  gnome-terminal python-gpg gnome-system-monitor \
xdotool python3-lxml composer php-mysql typora
#----------------------------- når privat pc ----------------------------------------------
sudo apt install -y  asc crimson extremetuxracer freeciv-client-sdl supertuxkart supertux torcs trigger-rally uligo unknown-horizons wesnoth steam thunar-dropbox-plugin


#DEFAULT PIP PACKAGES:
pip3 install -U autopep8 --user
python3 -m pip install -U rope --user
pip3 install ttkthemes unoconv pyautogui epc virtualenv execsql


#TIKA:
export VER="1.20"
mkdir -p ~/bin/tika && cd ~/bin/tika && wget https://archive.apache.org/dist/tika/tika-app-${VER}.jar
#TODO: Lag desktop-fil/script for å åpne tika-app fra meny


#DOCKER:
sudo systemctl daemon-reload
sudo systemctl restart docker

#GIT:
#----------------------------- med proxy ----------------------------------------------
git config --global http.proxy http://85.19.187.24:8080
git config --global url.https://github.com/.insteadOf git://github.com/



#FIXES:
cat <<\EOF > ~/bin/div_fix.sh
#! /bin/bash
pkill gvfsd-fuse && /usr/lib/gvfs/gvfsd-fuse -o allow_other /var/run/user/1000/gvfs/
setxkbmap -option 'numpad:microsoft'
# xcape -e 'Super_L=Alt_L|F3'
EOF

chmod a+rx ~/bin/div_fix.sh


bash -c 'echo "[Desktop Entry]
Type=Application
Exec=/home/bba/bin/div_fix.sh
Hidden=false
X-MATE-Autostart-enabled=true
Name=Div_Fix" > ~/.config/autostart/Div_Fix.desktop'


#ORACLE 11 XE:
# TODO: Før hente script fra hvor og lagre i /tmp
cd /tmp && bash oracle_11_xe_install.sh

echo 'export ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"' | sudo tee -a /root/.bashrc
echo 'export ORACLE_SID=XE' | sudo tee -a /root/.bashrc
sudo bash -c 'echo "bba ALL = (root) NOPASSWD: /etc/init.d/oracle-xe" > /etc/sudoers.d/xe'
sudo chmod 0440 /etc/sudoers.d/xe

# TODO: Fiks at må kjøre denne manuelt: "$ORACLE_HOME"/bin/lsnrctl start && sudo /etc/init.d/oracle-xe start

# cat <<\EOF > ~/bin/ora_start.sh
# #! /bin/bash
# "$ORACLE_HOME"/bin/lsnrctl start && sudo /etc/init.d/oracle-xe start
# EOF
# chmod 775 ~/bin/ora_start.sh

# sudo bash -c "echo '[Unit]
# Description=Start Oracle

# [Service]
# Type=oneshot
# ExecStart=/bin/sh /home/bba/bin/ora_start.sh

# [Install]
# WantedBy=multi-user.target' >> /etc/systemd/system/ora_start.service"

# sudo systemctl enable ora_start.service

#MYSQL:
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-codename select bionic'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-preview select '
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select '
sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/unsupported-platform select abort'
cd /tmp
wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
sudo DEBIAN_FRONTEND=noninteractive dpkg --install mysql-apt-config_0.8.12-1_all.deb
sudo apt-get update
sudo apt-get install -y -E mysql-community-server #TODO: gjør noninteractive (satte tomt passord)
sudo systemctl enable mysql
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'"

#POSTGRESQL:
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service
#TODO: Gjør det under noninterctive
sudo -u postgres psql postgres
\password postgres
#passord satt til bba
\q
sudo su - postgres
psql
CREATE ROLE bba SUPERUSER LOGIN REPLICATION CREATEDB CREATEROLE; CREATE DATABASE bba OWNER bba; ALTER USER bba WITH PASSWORD 'bba'; \q
exit

#MSSQL:
# Gjør linje under noninteractive. Valgte 3 (express), P@ssw0rd
sudo /opt/mssql/bin/mssql-conf setup

#PWB:
# TODO: Oppdater med denne:
cd ~/bin && git clone https://github.com/BBATools/PreservationWorkbench.git PWB2 &&
cd PWB2/bin  && wget -qO- -O tmp.zip https://www.sql-workbench.eu/Workbench-Build125.zip && unzip tmp.zip && rm tmp.zip


cd /home/bba/bin/PWB/bin
#Kopierte PWB-mappe til /home/bba/bin/PWB/bin -> TODO: Automatiser inkl linje under senere
#mkdir -p ~/bin/PWB && cd ~/bin/PWB && wget -qO- -O tmp.zip https://www.sql-workbench.eu/Workbench-Build124.zip && unzip tmp.zip && rm tmp.zip
ln -s ~/bin/PWB/PWB.sh ~/bin
cd ~/bin/PWB/bin
# TODO: Linjen under virket ikke -> sjekk om navn på dekstop-fil er endret
sed -i 's:java -jar sqlworkbench.jar:PWB.sh:g' /home/bba/bin/PWB/bin/sqlworkbench.desktop
# TODO: Måtte likevel sette bildefil manuelt etterpå. Hvorfor?
sed -i 's:workbench32.png:/home/bba/bin/PWB/bin/workbench32.png:g' /home/bba/bin/PWB/bin/sqlworkbench.desktop
cp sqlworkbench.desktop ~/.local/share/applications/

#ANTIVIRUS:
#Last ned sophos til /home/bba/Downloads/sophos-av
cd ~/Downloads/sophos-av && sudo sh ./install.sh --acceptlicence
#TODO: Bruke dette valget auto når på adm-sone: --update-proxy-address=http://85.19.187.24:8080
#valg for install: default location, ikke on-access, oppdatering fra sophos, free version,
sudo /opt/sophos-av/bin/savdctl disable
sudo /opt/sophos-av/bin/savconfig set LiveProtection false
sudo /opt/sophos-av/bin/savconfig set DisableFeedback true
sudo sed -i -e 's/#user_allow_other/user_allow_other/' /etc/fuse.conf


composer php-mysql

#URD
cd ~/bin &&
git clone https://github.com/fkirkholt/urd.git &&
cd urd &&
composer install

# TODO:
# -Lag script for å endre whisker-menu til ALT-F1 (gjort manuelt nå - trengs for xcape over)
# - alias emacs='amacs' --> denne i tillegg eller heller enn endring av desktop-fil som nå?




