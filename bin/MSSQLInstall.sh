#!/bin/bash
killall synaptic;

if [ ! -f /tmp/microsoft.gpg ]; then
    cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
    install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg;
fi


isInFile=$(cat /etc/apt/sources.list.d/prod.list | grep -c "https://packages.microsoft.com/ubuntu/20.04/prod")
if [ $isInFile -eq 0 ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/prod.list;
fi

apt-get update;
ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev freetds-dev freetds-bin unixodbc-dev tdsodbc; # mssql-server 

# isInFile=$(cat /etc/apt/sources.list.d/mssql-server-2019.list | grep -c "https://packages.microsoft.com/ubuntu/18.04/mssql-server-2019")
# if [ $isInFile -eq 0 ]; then
#     echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/18.04/mssql-server-2019 bionic main" > /etc/apt/sources.list.d/mssql-server-2019.list;
# fi

# Workaround for recurring index hash error on package server:
if [ $(dpkg-query -W -f='${Status}' mssql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    #cd /tmp && wget -c https://packages.microsoft.com/ubuntu/18.04/mssql-server-2019/pool/main/m/mssql-server/mssql-server_15.0.4073.23-4_amd64.deb
    #sudo DEBIAN_FRONTEND=noninteractive dpkg --install mssql-server_15.0.4073.23-4_amd64.deb
    # Downgrade as workaround for yet another longstanding bug:
    cd /tmp && wget -c https://packages.microsoft.com/ubuntu/16.04/mssql-server-preview/pool/main/m/mssql-server/mssql-server_15.0.1800.32-1_amd64.deb
    sudo DEBIAN_FRONTEND=noninteractive dpkg --install mssql-server_15.0.1800.32-1_amd64.deb    
fi 


if [ -f "/opt/mssql/bin/mssql-conf" ]; then
    export ACCEPT_EULA="Y"
    export MSSQL_PID="Express"
    export MSSQL_SA_PASSWORD="P@ssw0rd"
    /opt/mssql/bin/mssql-conf -n setup accept-eula
fi

sudo systemctl enable mssql-server
sudo systemctl start mssql-server
