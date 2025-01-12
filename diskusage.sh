#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
THRESHOLD=5 #generally we take 70 in normal servers
MSG=""
while read -r line
do
    USAGE=$(echo $line | awk -F " " '{print $6F}'| cut -d "%" -f1)
    PARTITION=$(echo $line | awk -F " " '{print $NF}')
    echo "Print partition: $PARTITION usage: $USAGE"
    if [ $USAGE -ge 5 ]
    then
        MSG+="High Disk usage on partition: $PARTITION usage is : $USAGE \n"        
    fi
done <<< $DISK_USAGE

echo -e "Message : $MSG"

echo "$MSG" | mutt -s "High Disk Usage" desfureanjek@gmail.com