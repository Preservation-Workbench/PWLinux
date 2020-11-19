#!/bin/bash
#SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
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

sudo -H -u $OWNER bash -c "cat <<\EOF > /home/$OWNER/bin/urd.sh
#!/bin/bash

sudo systemctl start mysql &&
cd ~/bin/URD/public && 
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
Icon=/usr/share/icons/Papirus/symbolic/apps/google-chrome-symbolic.svg
Terminal=false
Categories=Development;
Type=Application
Name[en_US]=URD
EOF
"



