SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
SIARDDIR=/home/$OWNER/bin/sfa-siard

/usr/lib/jvm/bellsoft-java8-runtime-full-amd64/bin/java  -Xmx1024m -Dsun.awt.disablegrab=true -Djava.util.logging.config.file=$SIARDDIR/etc/logging.properties -jar $SIARDDIR/lib/siardgui.jar
