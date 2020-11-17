#!/bin/bash
killall synaptic;

apt-get update;
apt-get install -y mysql-server-8.0 expect;

MYSQL_ROOT_PASSWORD='P@ssw0rd'
MYSQL=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $11}')
expect -c "
    set timeout 10
    spawn mysql_secure_installation

    expect \"Enter password for user root:\"
    send \"$MYSQL\r\"
    expect \"New password:\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Re-enter new password:\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Change the password for root ?\ ((Press y\|Y for Yes, any other key for No) :\"
    send \"y\r\"
    send \"$MYSQL\r\"
    expect \"New password:\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Re-enter new password:\"
    send \"$MYSQL_ROOT_PASSWORD\r\"
    expect \"Do you wish to continue with the password provided?\(Press y\|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect \"Remove anonymous users?\(Press y\|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect \"Disallow root login remotely?\(Press y\|Y for Yes, any other key for No) :\"
    send \"n\r\"
    expect \"Remove test database and access to it?\(Press y\|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect \"Reload privilege tables now?\(Press y\|Y for Yes, any other key for No) :\"
    send \"y\r\"
    expect eof
    "

mysql -e "CREATE USER IF NOT EXISTS 'pwb'@'localhost' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';"
mysql -e "GRANT ALL ON *.* TO 'pwb'@'localhost' WITH GRANT OPTION;FLUSH PRIVILEGES;"

# TODO: Lag tilsvarende som for mssql så bruker kan starte/stoppe alle databaser
# echo "$OWNER ALL=(ALL) NOPASSWD: /bin/systemctl start mssql-server.service,/bin/systemctl stop mssql-server.service" > /etc/sudoers.d/mssql;
# sudo chmod 0440 /etc/sudoers.d/mssql;  


