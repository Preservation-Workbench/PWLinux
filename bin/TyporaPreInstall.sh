#!/bin/bash

isInFile=$(cat /etc/apt/sources.list | grep -c "https://typora.io/linux")
if [ $isInFile -eq 0 ]; then
    wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
    echo -e "\ndeb https://typora.io/linux ./" | sudo tee -a /etc/apt/sources.list
    apt-get update
fi



