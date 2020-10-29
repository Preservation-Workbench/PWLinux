#!/bin/bash

apt-get install -y mysql-server-8.0;

sudo mysql -e "SET PASSWORD FOR root@localhost = PASSWORD('P@ssw0rd');FLUSH PRIVILEGES;"
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
sudo mysql -e "DROP DATABASE test;DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';"
sudo mysql -u root -psomething -e "CREATE USER 'pwb'@'localhost' IDENTIFIED BY 'P@ssw0rd';GRANT ALL PRIVILEGES ON *.* TO 'pwb'@'localhost';FLUSH PRIVILEGES;"

sudo systemctl enable mysql;
sudo systemctl start mysql;
