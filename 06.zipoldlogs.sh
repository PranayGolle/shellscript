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
    echo -e "$R USAGE:: $N sh 06.zipoldlogs.sh <SOURCE> <DESTINY> <DAYS (OPTIONAL)>
    exit 1
}

mkdir -p /home/ec2-user/shellscript-logs/

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE ]
then
    echo -e "$SOURCE does not exit please check"
    exit 1
fi

#if [ ! -d $DESTINY ]
#then
#    echo -e "$DESTINY does not exit...please check"
#fi
#echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

#FILES=$(find $SOURCE -name "*.log" -mtime $DAYS)
#   echo -e "files are : $FILES"