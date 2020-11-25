#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

# WAIT: Lag menyvalg + kopier eller lenke executables til path

if [ ! -f /home/$OWNER/bin/verapdf/verapdf ]; then
    rm -rdf /tmp/verapdf-*
    sudo -H -u $OWNER bash -c '
    mkdir -p /home/'"$OWNER"'/bin/verapdf;
    wget -O /tmp/verapdf-installer.zip http://downloads.verapdf.org/rel/verapdf-installer.zip
    unzip /tmp/verapdf-installer.zip;
    cd /tmp/verapdf-greenfield-*;
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
    cd $SCRIPTPATH;
    ln -s /home/'"$OWNER"'/bin/verapdf/verapdf /home/'"$OWNER"'/bin/verapdf.sh;'
fi

cd $SCRIPTPATH;
