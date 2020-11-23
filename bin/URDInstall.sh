#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

# Install MySQL if not done:
if [ ! -f "/etc/sudoers.d/mysql" ]; then
    source $SCRIPTPATH/MySQLInstall.sh
fi   

apt-get update;
apt install -y composer php-mysql;

REPOSRC="https://github.com/fkirkholt/urd.git"
LOCALREPO="/home/$OWNER/bin/URD"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull; \
cd /home/$OWNER/bin/URD/ && composer install;";

# Create urd-user/schema if not done:
USER_EXISTS="$(mysql -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'urd')")"
if [ "$USER_EXISTS" -ne 1 ]; then
    mysql -h localhost < $LOCALREPO/schemas/urd/sql/create_tables_mysql.sql;
fi   

# Autostart urd
$CMD="/usr/bin/php -S localhost:8000 -t ~/bin/URD/public & disown"
isInFile=$(cat /home/$OWNER/.profile | grep -c $CMD)
if [ $isInFile -eq 0 ]; then
    sudo -H -u $OWNER bash -c "echo "" >> /home/$OWNER/.profile;";
    sudo -H -u $OWNER bash -c "echo $CMD >> /home/$OWNER/.profile";
fi

# Add urd bookmark to chromium:
CHRMDFLT="/home/$OWNER/.config/chromium/Default"
if [ ! -f $CHRMDFLT/Bookmarks ]; then
    sudo -H -u $OWNER bash -c "mkdir -p $CHRMDFLT;";
    sudo -H -u $OWNER bash -c "cp $SCRIPTPATH/data/chromium/Bookmarks $CHRMDFLT/Bookmarks"
fi    

cd $SCRIPTPATH;