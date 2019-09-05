#!/bin/bash

#Mint xfce 19.1
# TODO: endre startside i firefox -> script senere
# TODO: Endre til kun ett workspace i fxce -> script senere

# TODO:
# git config --global user.email "mortenee@gmail.com"
# git config --global user.name "mortenee"


#USER:
#----------------------------- når VM ----------------------------------------------
sudo usermod -aG vboxsf $USER
sudo usermod -aG docker $USER

#-------------
sudo apt-key adv --keyserver-options http-proxy=http://85.19.187.24:8080 --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys F3503FFDFA132F65E151D87CDCDE74FDB4591784
sudo add-apt-repository "deb http://ppa.launchpad.net/sandromani/gimagereader/ubuntu bionic main"
#----------------------------- uten proxy ----------------------------------------------
sudo add-apt-repository -y ppa:sandromani/gimagereader
#----------------------------- alle ----------------------------------------------
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable"

docker-ce docker-compose gimagereader
xfpanel-switch thunar-vcs-plugin thunar-gtkhash  gnome-terminal python-gpg gnome-system-monitor \

#----------------------------- når privat pc ----------------------------------------------
sudo apt install -y  asc crimson extremetuxracer freeciv-client-sdl supertuxkart supertux torcs trigger-rally uligo unknown-horizons wesnoth steam

#DOCKER:
sudo systemctl daemon-reload
sudo systemctl restart docker

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


# TODO:
# -Lag script for å endre whisker-menu til ALT-F1 (gjort manuelt nå - trengs for xcape over)
# - alias emacs='amacs' --> denne i tillegg eller heller enn endring av desktop-fil som nå?




