#!/bin/bash

if [ $(dpkg-query -W -f='${Status}' mssql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;
    add-apt-repository "deb https://packages.microsoft.com/ubuntu/16.04/mssql-server-preview/ xenial main" # TODO: Endre repo når tilgjengelig for 18.04
    apt-get update;
    apt-get install -y mssql-server;
fi

export ACCEPT_EULA="Y"
export MSSQL_PID="Express"
export MSSQL_SA_PASSWORD="P@ssw0rd"
/opt/mssql/bin/mssql-conf -n setup accept-eula

sudo systemctl enable mssql-server
sudo systemctl start mssql-server

