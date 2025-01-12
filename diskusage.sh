#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
THRESHOLD=5 #generally we take 70 in normal servers

while read -r line
do
    USAGE=$(echo $line | awk -F " " '{print $6F}'| cut -d "%" -f1)
    echo "Print disk usage: $USAGE"
done <<< $DISK_USAGE