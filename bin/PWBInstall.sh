#!/bin/bash

# TODO: bruk clone --depth 1

isInFile=$(cat /etc/apt/sources.list | grep -c "https://download.onlyoffice.com/repo/debian")
if [ $isInFile -eq 0 ]; then
    curl -sSL 'https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xe09ca29f6e178040ef22b4098320ca65cb2de8e5' | sudo apt-key add -;
    echo "deb https://download.onlyoffice.com/repo/debian squeeze main" >> /etc/apt/sources.list;
    apt-get update;
fi

apt-get install -y wimtools python3-pandas graphviz python3-lxml openjdk-11-jdk img2pdf imagemagick python3-pgmagick graphicsmagick onlyoffice-documentbuilder abiword wkhtmltopdf;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)

REPOSRC="https://github.com/BBATools/PreservationWorkbench.git"
LOCALREPO="/home/$OWNER/bin/PWB"
sudo -H -u $OWNER bash -c "git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull -X theirs"

# WAIT: pull -X theirs også for andre?

if [ ! -f $LOCALREPO/bin/sqlworkbench.jar ]; then
    sudo -H -u $OWNER bash -c "cd /home/$OWNER/bin/PWB/bin && \
    wget -qO tmp.zip https://www.sql-workbench.eu/Workbench-Build125.zip && unzip -o tmp.zip && rm tmp.zip; \
    ln -s /home/$OWNER/bin/PWB/bin/pwb.sh /home/$OWNER/bin; \
    sed -i 's:java -jar sqlworkbench.jar:/home/$OWNER/bin/PWB/bin/pwb.sh:g' sqlworkbench.desktop; \
    sed -i 's:workbench32.png:/home/$OWNER/bin/PWB/bin/workbench32.png:g' sqlworkbench.desktop; \
    cp sqlworkbench.desktop /home/$OWNER/.local/share/applications/";
fi

if [ ! -f $LOCALREPO/bin/ojdbc10.jar ]; then
    if [ -f $SCRIPTPATH/ojdbc10.jar ]; then
        sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/ojdbc10.jar $LOCALREPO/bin/";
    fi
fi


# if ! [ -x "$(command -v savscan)" ]; then
#     if [ -f $SCRIPTPATH/sav-linux-free-9.tgz ]; then
#         sudo -H -u $OWNER bash -c "tar zxvf $SCRIPTPATH/sav-linux-free-9.tgz;";

#         ENV_PROXY=$( env | grep https_proxy | cut -c 13- | rev | cut -c 2- | rev )
#         if [ -z "$ENV_PROXY" ]; then
#             $SCRIPTPATH/sophos-av/install.sh --acceptlicence --automatic --live-protection=False --SavWebUsername=pwb --SavWebPassword=pwb --update-free=True --update-period=24 --update-type=f /opt/sophos-av;
#         else
#             $SCRIPTPATH/sophos-av/install.sh --acceptlicence --automatic --update-proxy-address=$ENV_PROXY --live-protection=False --SavWebUsername=pwb --SavWebPassword=pwb --update-free=True --update-period=24 --update-type=f /opt/sophos-av;
#         fi

#         /opt/sophos-av/bin/savdctl disable;
#         /opt/sophos-av/bin/savdctl disableOnBoot;
#         /opt/sophos-av/bin/savconfig set DisableFeedback true;
#         rm -rdf $SCRIPTPATH/sophos-av
#         /opt/sophos-av/bin/savupdate
#     fi
# fi

systemctl enable clamav-daemon
systemctl start clamav-daemon

sed -i -e 's/#user_allow_other/user_allow_other/' /etc/fuse.conf;

if [ -f "/etc/ImageMagick-6/policy.xml" ]; then
    mv /etc/ImageMagick-6/policy.xml /etc/ImageMagick-6/policy.xmlout  2>/dev/null;
fi


# WAIT: Lag menyvalg + kopier eller lenke executables til path

if [ ! -f /home/$OWNER/bin/verapdf/verapdf ]; then
rm -rdf /tmp/verapdf-*
sudo -H -u $OWNER bash -c '
mkdir -p /home/'"$OWNER"'/bin/verapdf;
cd /tmp && wget http://downloads.verapdf.org/rel/verapdf-installer.zip
unzip verapdf-installer.zip;
cd verapdf-greenfield-*;
cat <<\EOF > auto.xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<AutomatedInstallation langpack="eng">
<com.izforge.izpack.panels.htmlhello.HTMLHelloPanel id="welcome"/>
<com.izforge.izpack.panels.target.TargetPanel id="install_dir">
<installpath>/home/'"$OWNER"'/bin/verapdf</installpath>
</com.izforge.izpack.panels.target.TargetPanel>
<com.izforge.izpack.panels.packs.PacksPanel id="sdk_pack_select">
<pack index="0" name="veraPDF GUI" selected="true"/>
<pack index="1" name="veraPDF Mac and *nix Scripts" selected="true"/>
<pack index="2" name="veraPDF Corpus and Validation model" selected="false"/>
<pack index="3" name="veraPDF Documentation" selected="true"/>
<pack index="4" name="veraPDF Sample Plugins" selected="false"/>
</com.izforge.izpack.panels.packs.PacksPanel>
<com.izforge.izpack.panels.install.InstallPanel id="install"/>
<com.izforge.izpack.panels.finish.FinishPanel id="finish"/>
</AutomatedInstallation>
EOF
java -jar verapdf-izpack-installer-* auto.xml;
ln -s /home/'"$OWNER"'/bin/verapdf/verapdf /home/'"$OWNER"'/bin/verapdf.sh;'
fi


