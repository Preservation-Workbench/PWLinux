#!/bin/bash

#isInFile=$(cat /etc/apt/sources.list | grep -c "http://apt.postgresql.org/pub/repos/apt/")
#if [ $isInFile -eq 0 ]; then
    #wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    #echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list
    #apt-get update
#fi

if [ $(dpkg-query -W -f='${Status}' postgresql-11 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -;
    echo "deb http://apt.postgresql.org/pub/repos/apt/ bionic-pgdg main" > /etc/apt/sources.list.d/PostgreSQL.list;
    apt-get update;
    apt-get install -y postgresql-11;
    systemctl enable postgresql.service;
    systemctl start postgresql.service;
fi

sudo -H -u postgres bash -c 'psql --command "ALTER USER postgres PASSWORD '\''P@ssw0rd'\'';"';


