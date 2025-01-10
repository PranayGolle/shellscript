#!/bin/bash

source ./source.sh

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +14)
echo "files to be deleted: $FILES_TO_DELETE"

while read -r file
do
    echo "deleting the files: $file"
    rm -rf $file
done<<<FILE_TO_DELETE
