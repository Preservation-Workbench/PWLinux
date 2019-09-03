#!/bin/bash

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list'

apt-get install postgresql-11


#POSTGRESQL:
sudo systemctl enable postgresql.service
sudo systemctl start postgresql.service
#TODO: Gjør det under noninterctive
sudo -u postgres psql postgres
\password postgres
#passord satt til bba
\q
sudo su - postgres
psql
CREATE ROLE bba SUPERUSER LOGIN REPLICATION CREATEDB CREATEROLE; CREATE DATABASE bba OWNER bba; ALTER USER bba WITH PASSWORD 'bba'; \q
exit


#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-codename select bionic'
#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-distro select ubuntu'
#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/repo-url string http://repo.mysql.com/apt/'
#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-preview select '
#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-product select Ok'
#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-server select mysql-8.0'
#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/select-tools select '
#sudo debconf-set-selections <<< 'mysql-apt-config mysql-apt-config/unsupported-platform select abort'
#sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/root-pass password P@ssw0rd'
#sudo debconf-set-selections <<< 'mysql-community-server mysql-community-server/re-root-pass password P@ssw0rd'
##sudo debconf-set-selections <<< 'mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)'
#cd /tmp
#wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.12-1_all.deb
#sudo DEBIAN_FRONTEND=noninteractive dpkg --install mysql-apt-config_0.8.12-1_all.deb
#sudo apt-get update
#sudo DEBIAN_FRONTEND=noninteractive apt install -y mysql-community-server
#sudo systemctl enable mysql
#sudo systemctl start mysql
##sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'"
