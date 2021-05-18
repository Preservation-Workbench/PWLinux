#!/bin/bash -e

# Based on these: 
# https://github.com/Vincit/travis-oracledb-xe
# https://github.com/cbandy/travis-oracle/blob/master/install.sh
#
# Copyright (c) 2013, Christopher Bandy
#
# Permission to use, copy, modify, and/or distribute this software for any purpose with or without fee is hereby granted,
# provided that the above copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
# NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH);
ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"
ORACLE_SID=XE
sqlplus_path="$ORACLE_HOME/bin/sqlplus"

if [ ! -f $sqlplus_path ]; then
    export ORACLE_HOME
    export ORACLE_SID
    export ORACLE_FILE="/tmp/oracle-xe-11.2.0-1.0.x86_64.rpm.zip"
    ORACLE_RPM="$(basename $ORACLE_FILE .zip)"

    # make sure that hostname is found from hosts (or oracle installation will fail)
    ping -c1 $(hostname) || echo 127.0.0.1 $(hostname) | sudo tee -a /etc/hosts

    cd /tmp
    if [ ! -f $ORACLE_RPM ]; then
        curl -LO https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.aa
        curl -LO https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.ab
        curl -LO https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.ac
        curl -LO https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.ad    
        # curl -LO --doh-url https://1.1.1.1/dns-query https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.aa
        # curl -LO --doh-url https://1.1.1.1/dns-query https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.ab
        # curl -LO --doh-url https://1.1.1.1/dns-query https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.ac
        # curl -LO --doh-url https://1.1.1.1/dns-query https://raw.githubusercontent.com/Preservation-Workbench/travis-oracledb-xe/master/packages/oracle-xe-11.2.0-1.0.x86_64.rpm.zip.ad
        cat oracle-xe-11.2.0-1.0.x86_64.rpm.zip.* > oracle-xe-11.2.0-1.0.x86_64.rpm.zip
        #cd $SCRIPTPATH
        dpkg -s bc libaio1 rpm unzip > /dev/null 2>&1 ||
          ( sudo apt-get -qq update && sudo apt-get --no-install-recommends -qq install bc libaio1 rpm unzip )

        df -B1 /dev/shm | awk 'END { if ($1 != "shmfs" && $1 != "tmpfs" || $2 < 2147483648) exit 1 }' ||
          ( sudo rm -r /dev/shm && sudo mkdir /dev/shm && sudo mount -t tmpfs shmfs -o size=2G /dev/shm )

        test -f /sbin/chkconfig ||
          ( echo '#!/bin/sh' | sudo tee /sbin/chkconfig > /dev/null && sudo chmod u+x /sbin/chkconfig )

        test -d /var/lock/subsys || sudo mkdir /var/lock/subsys

        unzip -j "$(basename $ORACLE_FILE)" "*/$ORACLE_RPM"
    fi

    sudo rpm --install --force --nodeps --nopre "$ORACLE_RPM"
    
    echo 'ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"' >> /home/$OWNER/.bashrc
    echo 'ORACLE_SID=XE' >> /home/$OWNER/.bashrc
    echo 'ORACLE_HOME="/u01/app/oracle/product/11.2.0/xe"' >> /etc/environment
    echo 'ORACLE_SID=XE' >> /etc/environment

    echo 'OS_AUTHENT_PREFIX=""' | sudo tee -a "$ORACLE_HOME/config/scripts/init.ora" > /dev/null

    sudo usermod -aG dba $OWNER
    sudo usermod -aG dba oracle
    sudo usermod -aG dba root

    #sed -i '/CONFIGURE_RUN=true/c\CONFIGURE_RUN=false' /etc/default/oracle-xe; # Not enough to change this
    ( echo ; echo ; echo $OWNER ; echo $OWNER ; echo n ) | sudo AWK='/usr/bin/awk' /etc/init.d/oracle-xe configure

    /etc/init.d/oracle-xe start && "$ORACLE_HOME"/bin/lsnrctl reload
    chown oracle:dba /var/tmp/.oracle

    #Fix desktop icons:
    rm -f /home/$OWNER/Desktop/oraclexe-gettingstarted.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-getstarted.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-gettingstarted.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-backup.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-gotoonlineforum.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-registerforonlineforum.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-restore.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-runsql.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-startdb.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-stopdb.desktop
    sed -zi '/NoDisplay=true/!s/$/\nNoDisplay=true/' /usr/share/applications/oraclexe-readdocumentation.desktop

    echo "$OWNER ALL=(ALL) NOPASSWD: /etc/init.d/oracle-xe" > /etc/sudoers.d/xe;
    chmod 0440 /etc/sudoers.d/xe;    

	rm -rdf /home/$OWNER/oradiag_root;    
fi

# TODO: Legg inn sjekk på om bruker finnes først
su oracle -m -c "$ORACLE_HOME/bin/sqlplus -L -S / AS SYSDBA <<SQL
CREATE USER oracle IDENTIFIED BY "\""P@ssw0rd"\"";
GRANT CREATE SESSION, GRANT ANY PRIVILEGE TO oracle;
GRANT ALL PRIVILEGES TO oracle;
GRANT CONNECT, RESOURCE TO oracle;
GRANT EXECUTE ON SYS.DBMS_LOCK TO oracle;
ALTER PROFILE DEFAULT LIMIT PASSWORD_VERIFY_FUNCTION NULL;
ALTER DATABASE DATAFILE '/u01/app/oracle/oradata/XE/system.dbf' AUTOEXTEND ON MAXSIZE 15G;
SQL"

cd $SCRIPTPATH;
