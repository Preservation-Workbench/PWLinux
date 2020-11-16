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

#sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'P@ssw0rd';"
# # TODO: Linje over gir FM:
# Enter password for user root: 
# Error: Access denied for user 'root'@'localhost' (using password: NO)
# send: spawn id exp4 not open
#     while executing
# "send "P@ssw0rd\r""


