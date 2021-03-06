#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

apt-get update;
apt-get install -y mysql-server-8.0 expect;

MYSQL_ROOT_PASSWORD='P@ssw0rd'
MYSQL=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $11}')
if [ ! -f "/etc/sudoers.d/mysql" ]; then
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

    echo "$OWNER ALL=(ALL) NOPASSWD: /bin/systemctl start mysql,/bin/systemctl stop mysql" > /etc/sudoers.d/mysql;
    sudo chmod 0440 /etc/sudoers.d/mysql;  
    systemctl enable mysql; # Needed by urd            
fi

cd $SCRIPTPATH;

   






