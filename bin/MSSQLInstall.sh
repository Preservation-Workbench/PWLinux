#!/bin/bash

if [ ! -f /tmp/microsoft.gpg ]; then
    cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
    install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg;
fi

isInFile=$(cat /etc/apt/sources.list.d/mssql-server-2019.list | grep -c "https://packages.microsoft.com/ubuntu/18.04/mssql-server-2019")
if [ $isInFile -eq 0 ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/18.04/mssql-server-2019 bionic main" > /etc/apt/sources.list.d/mssql-server-2019.list;
fi

isInFile=$(cat /etc/apt/sources.list.d/prod.list | grep -c "https://packages.microsoft.com/ubuntu/20.04/prod")
if [ $isInFile -eq 0 ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/prod.list;
fi

apt-get update;
apt-get install -y mssql-server mssql-tools unixodbc-dev freetds-dev freetds-bin unixodbc-dev tdsodbc;

export ACCEPT_EULA="Y"
export MSSQL_PID="Express"
export MSSQL_SA_PASSWORD="P@ssw0rd"
/opt/mssql/bin/mssql-conf -n setup accept-eula

sudo systemctl enable mssql-server
sudo systemctl start mssql-server