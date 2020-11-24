#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

# Install OnlyOffice:
source $SCRIPTPATH/OnlyofficeInstall.sh

REPOSRC="https://github.com/Preservation-Workbench/PWCode"
LOCALREPO="/home/$OWNER/bin/PWCode"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" 2> \
    /dev/null || git -C "$LOCALREPO" pull;";

source $LOCALREPO/bin/installers.sh
sudo -H -u $OWNER bash -c "install_python_runtime";
sudo -H -u $OWNER bash -c "install_python_packages";
sudo -H -u $OWNER bash -c "install_java";
sudo -H -u $OWNER bash -c "install_jars";
sudo -H -u $OWNER bash -c "install_ojdbc";



##################################################################




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


