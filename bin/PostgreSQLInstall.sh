#!/bin/bash

apt-get update;
apt-get install -y postgresql-12 postgresql-autodoc postgresql-plpython3-12;

systemctl enable postgresql.service;
systemctl start postgresql.service;

sudo -H -u postgres bash -c 'psql --command "ALTER USER postgres PASSWORD '\''P@ssw0rd'\'';"';

