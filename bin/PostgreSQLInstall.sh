#!/bin/bash
killall synaptic;

apt-get update;
apt-get install -y postgresql-12 postgresql-autodoc postgresql-plpython3-12;

systemctl enable postgresql.service;
systemctl start postgresql.service;

sudo -i -u postgres bash -c \
    'psql --command "ALTER USER postgres PASSWORD '\''P@ssw0rd'\'';"';

# TODO: Lag tilsvarende som for mssql så bruker kan starte/stoppe alle databaser
# echo "$OWNER ALL=(ALL) NOPASSWD: /bin/systemctl start mssql-server.service,/bin/systemctl stop mssql-server.service" > /etc/sudoers.d/mssql;
# sudo chmod 0440 /etc/sudoers.d/mssql;  

