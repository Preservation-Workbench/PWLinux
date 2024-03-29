#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);

if [ ! -f /tmp/microsoft.gpg ]; then
    cd /tmp && curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg;
    install -o root -g root -m 644 /tmp/microsoft.gpg /usr/share/keyrings/microsoft-archive-keyring.gpg;
fi

isInFile=$(cat /etc/apt/sources.list.d/prod.list | grep -c "https://packages.microsoft.com/ubuntu/20.04/prod")
if [ $isInFile -eq 0 ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/20.04/prod focal main" > /etc/apt/sources.list.d/prod.list;
fi


# Need repo for dependencies for manual install also:
isInFile=$(cat /etc/apt/sources.list.d/mssql-server-2019.list | grep -c "https://packages.microsoft.com/ubuntu/20.04/mssql-server-2019")
if [ $isInFile -eq 0 ]; then
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/ubuntu/20.04/mssql-server-2019 focal main" > /etc/apt/sources.list.d/mssql-server-2019.list;
fi

apt-get update;
ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev freetds-dev freetds-bin unixodbc-dev tdsodbc mssql-server 

# apt-get update;
# ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev freetds-dev freetds-bin unixodbc-dev tdsodbc python-is-python2; # mssql-server 


# Workaround for recurring index hash error on package server:
# if [ $(dpkg-query -W -f='${Status}' mssql-server 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
#     apt-get install -y libc++1 libc++abi1 libsasl2-modules-gssapi-mit libsss-nss-idmap0;  
#     cd /tmp/ && wget -c https://packages.microsoft.com/ubuntu/18.04/mssql-server-2019/pool/main/m/mssql-server/mssql-server_15.0.4073.23-4_amd64.deb
#     sudo DEBIAN_FRONTEND=noninteractive dpkg --install mssql-server_15.0.4073.23-4_amd64.deb
# fi 

systemctl stop mssql-server; # Stop server if already running

if [ -f "/opt/mssql/bin/mssql-conf" ]; then
    export ACCEPT_EULA="Y"
    export MSSQL_PID="Express"
    export MSSQL_SA_PASSWORD="P@ssw0rd"
    /opt/mssql/bin/mssql-conf -n setup accept-eula;
    echo "$OWNER ALL=(ALL) NOPASSWD: /bin/systemctl start mssql-server,/bin/systemctl stop mssql-server" > /etc/sudoers.d/mssql;
    sudo chmod 0440 /etc/sudoers.d/mssql;  
fi

# Bug in mssql renders install unusable on virtualbox after power down if active as service 
systemctl disable mssql-server; 

cat << EOF | sudo tee /usr/local/sbin/pw_shutdown.sh
#!/bin/bash
sudo systemctl stop mssql-server
EOF

cat << EOF | sudo tee /etc/systemd/system/pw_shutdown.service
[Unit]
Description=
Before=shutdown.target reboot.target

[Service]
Type=oneshot
ExecStart=/bin/true
ExecStop=/usr/local/sbin/pw_shutdown.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable pw_shutdown.service

cd $SCRIPTPATH;