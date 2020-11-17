#!/bin/bash
killall synaptic;

apt-get update;
apt-get install -y postgresql-12 postgresql-autodoc postgresql-plpython3-12;

systemctl start postgresql;
sudo -i -u postgres bash -c \
    'psql --command "ALTER USER postgres PASSWORD '\''P@ssw0rd'\'';"';

# TODO: Lag tilsvarende som for mssql så bruker kan starte/stoppe alle databaser
# echo "$OWNER ALL=(ALL) NOPASSWD: /bin/systemctl start mssql-server.service,/bin/systemctl stop mssql-server.service" > /etc/sudoers.d/mssql;
# sudo chmod 0440 /etc/sudoers.d/mssql;  

echo "$OWNER ALL=(ALL) NOPASSWD: /bin/systemctl start postgresql,/bin/systemctl stop postgresql" > /etc/sudoers.d/postgresql;
sudo chmod 0440 /etc/sudoers.d/postgresql;  
systemctl disable postgresql;