#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
THRESHOLD=5 #generally we take 70 in normal servers

while read -r disk
do
    echo "Print disk usage: $DISK_USAGE"
done