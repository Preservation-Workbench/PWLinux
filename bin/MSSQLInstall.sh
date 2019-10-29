#!/bin/bash

sudo apt install libc++1 libc++abi1 libsasl2-modules-gssapi-mit libsss-nss-idmap0;

# TODO: Aktiver installasjon fra repo heller når feil med korrupt fil etter restart fikset av MS (er feil i versjon 15.0.1900.25-1)
if [ $(dpkg-query -W -f='${Status}' mssql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    #wget -qO- https://packages.microsoft.com/keys/microsoft.asc | apt-key add -;
    #add-apt-repository "deb https://packages.microsoft.com/ubuntu/16.04/mssql-server-preview/ xenial main" # TODO: Endre repo når tilgjengelig for 18.04
    #apt-get update;
    #apt-get install -y mssql-server;
    cd /tmp && wget -c https://packages.microsoft.com/ubuntu/16.04/mssql-server-preview/pool/main/m/mssql-server/mssql-server_15.0.1800.32-1_amd64.deb
    sudo DEBIAN_FRONTEND=noninteractive dpkg --install mssql-server_15.0.1800.32-1_amd64.deb
fi

export ACCEPT_EULA="Y"
export MSSQL_PID="Express"
export MSSQL_SA_PASSWORD="P@ssw0rd"
/opt/mssql/bin/mssql-conf -n setup accept-eula

sudo systemctl enable mssql-server
sudo systemctl start mssql-server

