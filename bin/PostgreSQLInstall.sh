#!/bin/bash
#SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

apt-get update;
apt-get install -y postgresql-12 postgresql-autodoc postgresql-plpython3-12;

systemctl start postgresql;
sudo -i -u postgres bash -c \
    'psql --command "ALTER USER postgres PASSWORD '\''P@ssw0rd'\'';"';

echo "$OWNER ALL=(ALL) NOPASSWD: /bin/systemctl start postgresql,/bin/systemctl stop postgresql" > /etc/sudoers.d/postgresql;
sudo chmod 0440 /etc/sudoers.d/postgresql;  
systemctl disable postgresql;