#!/bin/bash

source ./source.sh

FILES_TO_DELETE=$(find $SOURCE_DIR -name "*.log" -mtime +14)
echo "files to be deleted: $FILES_TO_DELETE"