#!/bin/bash


R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

SOURCE=$1
DESTINY=$2
DAYS=${3:-14} #HERE 14DAYS IS OPTIONAL HENCE IF WE DIDNT SPECIFY NO OF DAYS IT WILL TAKE 14DAYS AS DEFAULT


LOGS_FOLDER="/home/ec2-user/shellscript-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"



CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo "ERROR:: You musht have sudo access to execute this script"
        exit 1 #other than 0
    fi
}

USAGE(){
    echo -e "$R USAGE:: $N sh zipping.sh <SOURCE> <DESTINY> <DAYS (OPTIONAL)>"
    exit 1
}

echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

mkdir -p "/home/ec2-user/shellscript-logs/"

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE ]
then
    echo -e "$SOURCE does not exit please check"
    exit 1
fi

if [ ! -d $DESTINY ]
then
    echo -e "$DESTINY does not exit...please check"
    exit 1
fi

FILES=$(find $SOURCE -name "*.log" -mtime +$DAYS)
echo "files are found : $FILES"

if [ -n "$FILES" ]
then
    echo -e "files found and zipped all the files"
    ZIP_FILE="$DESTINY/app-logs-$TIMESTAMP.zip"
    (find $SOURCE -name "*.log" -mtime +$DAYS | zip -@$ZIP_FILE)
        if [ -f "$ZIP_FILE" ]
        then
            echo -e "sucessfully created zip file older than $DAYS"
            while read -r filepath
            do
                echo "deleting the files: $filepath" &>>$LOG_FILE_NAME
                rm -rf $filepath
                echo "deleted file: $filepath"
            done <<< $FILES
        else
            echo -e "$R ERROR :$N failed to create zip file"    
        fi
else
    echo -e "no files are found older than $DAYS"
fi