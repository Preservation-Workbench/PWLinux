#!/bin/bash
SCRIPTPATH=$(dirname $(readlink -f "${BASH_SOURCE[0]}" 2>/dev/null||echo $0))
OWNER=$(stat -c '%U' $SCRIPTPATH)

sudo -H -u $OWNER bash -c "export GOPATH=/home/$OWNER/bin/go && go get github.com/richardlehane/siegfried/cmd/sf"
sudo -H -u $OWNER bash -c "/home/$OWNER/bin/go/bin/sf -update"

isInFile=$(cat /home/$OWNER/.bashrc | grep -c "/bin/go/bin")
if [ $isInFile -eq 0 ]; then
    sudo -H -u $OWNER bash -c "echo 'export PATH=$PATH:/home/'"$OWNER"'/bin/go/bin' >> /home/$OWNER/.bashrc";
    sudo -H -u $OWNER bash -c "echo 'export GOPATH=/home/'"$OWNER"'/bin/go' >> /home/$OWNER/.bashrc";
fi

cd $SCRIPTPATH;

