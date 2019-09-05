#!/bin/bash

isInFile=$(cat /etc/apt/sources.list | grep -c "http://apt.postgresql.org/pub/repos/apt/")
if [ $isInFile -eq 0 ]; then
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list
    apt-get update
fi

apt-get install -y postgresql-11
systemctl enable postgresql.service
systemctl start postgresql.service

#sudo -H -u postgres bash -c 'psql --command "CREATE ROLE bba SUPERUSER LOGIN REPLICATION CREATEDB CREATEROLE; ALTER USER bba WITH PASSWORD '\''P@ssw0rd;'\''"';
# TODO: Endret fra den over -> ble passord satt feil da?
sudo -H -u postgres bash -c 'psql --command "CREATE ROLE bba SUPERUSER LOGIN REPLICATION CREATEDB CREATEROLE; ALTER USER bba WITH PASSWORD '\''P@ssw0rd'\'';"';
sudo -H -u postgres bash -c 'createdb -O bba bba';




