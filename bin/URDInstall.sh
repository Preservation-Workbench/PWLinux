#!/bin/bash

# Install MySQL if not done:
USER_EXISTS="$(mysql -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'pwb')")"
if [ "$USER_EXISTS" -ne 1 ]; then
    source $SCRIPTPATH/MySQLInstall.sh
fi   

apt-get update;
apt install -y composer php-mysql;

SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
OWNER=$(stat -c '%U' $SCRIPTPATH)

REPOSRC="https://github.com/fkirkholt/urd.git"
LOCALREPO="/home/$OWNER/bin/URD"
sudo -H -u $OWNER bash -c "git clone --depth 1 "$REPOSRC" "$LOCALREPO" 2> /dev/null || git -C "$LOCALREPO" pull; \
cd /home/$OWNER/bin/URD/ && composer install;";

# Create urd-user/schema if not done:
USER_EXISTS="$(mysql -sse "SELECT EXISTS(SELECT 1 FROM mysql.user WHERE user = 'urd')")"
if [ "$USER_EXISTS" -ne 1 ]; then
    mysql -h localhost < $LOCALREPO/schemas/urd/sql/create_tables_mysql.sql;
fi   

sudo -H -u $OWNER bash -c "cat <<\EOF > /home/$OWNER/bin/urd.sh
#!/bin/bash

sudo systemctl start mysql &&
cd ~/bin/URD/bin/URD/public && 
php -S localhost:8000 &&
chromium --app=localhost:8000
EOF
"
sudo -H -u $OWNER bash -c "chmod a+rx /home/$OWNER/bin/urd.sh;";

sudo -H -u $OWNER bash -c "mkdir -p /home/$OWNER/.local/share/applications;";
sudo -H -u $OWNER bash -c "cat <<\EOF > /home/$OWNER/.local/share/applications/urd.desktop
[Desktop Entry]
Name=URD
Exec=/home/$OWNER/bin/urd.sh
Icon=/usr/share/icons/Papirus/32x32/apps/0ad.svg
Terminal=false
Categories=Development;
Type=Application
Name[en_US]=URD
EOF
"



