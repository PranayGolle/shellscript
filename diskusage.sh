#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
THRESHOLD=5 #generally we take 70 in normal servers

while read -r line
do
    USAGE=$($DISK_USAGE | awk -F " " '{print $6F}')
    echo "Print disk usage: $USAGE"
done