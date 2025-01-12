#!/bin/bash

DISK_USAGE=$(df -hT | grep xfs)
THRESHOLD=5 #generally we take 70 in normal servers

while -r disk
do
    echo "Print disk usage: $DISK_USAGE"
done