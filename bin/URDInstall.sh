#!/bin/bash

apt-get update;
apt install -y composer php-mysql;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)

# Install MySQL:
source $SCRIPTPATH/MySQLInstall.sh

REPOSRC="https://github.com/fkirkholt/urd.git"
LOCALREPO="/home/$OWNER/bin/URD"
sudo -H -u $OWNER bash -c "git clone "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull; \
cd /home/$OWNER/bin/URD/ && composer install;";

# Create schema:
mysql -h localhost -u pwb < $LOCALREPO/schemas/urd/sql/create_tables_mysql.sql;


