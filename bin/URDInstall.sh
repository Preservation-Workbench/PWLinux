#!/bin/bash

apt install -y composer php-mysql;

OWNER=$(stat -c '%U' $PWD);
URD_DIR="~/bin/URD/.git/"
if [ ! -d "$URD_DIR" ]; then
    git clone https://github.com/fkirkholt/urd.git ~/bin/URD/;
    cd ~/bin/URD/ && composer install;
    chown -R $OWNER ~/bin/URD/;
fi

