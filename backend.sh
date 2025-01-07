#!/bin/bash

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shellscript-logs"
LOG_FILE=$(echo $0 | cut -d "." -f1 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

echo "Script started executing at: $TIMESTAMP" &>>$LOG_FILE_NAME

if [ $USERID -ne 0 ]
then
    echo "ERROR:: You must have sudo access to execute this script"
    exit 1 #other than 0
fi

dnf module disable nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "disable existing version of node"

dnf module enable nodejs:20 -y &>>$LOG_FILE_NAME
VALIDATE $? "enable node version 20"

dnf install nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "installing backend"

useradd expense &>>$LOG_FILE_NAME
VALIDATE $? "adding a user for our project"

mkdir /app

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "downloading backend zip file"

cd /app
unzip /tmp/backend.zip &>>$LOG_FILE_NAME
VALIDATE $? "unziping the backend file"

npm install &>>$LOG_FILE_NAME
VALIDATE $? "installing the supporting libraries"

cp /ec2-user/shellscript/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>$LOG_FILE_NAME
VALIDATE $? "installing sql client"

mysql -h mysql.pranayaws.site -uroot -pExpenseApp@1 < /app/schema/backend.sql

systemctl daemon-reload
systemctl restart backend
systemctl enable backend