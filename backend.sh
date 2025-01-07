#!/bin/bash

source ./source.sh

CHECK_ROOT

dnf module disable nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "disable existing version of node"

dnf module enable nodejs:20 -y &>>$LOG_FILE_NAME
VALIDATE $? "enable node version 20"

dnf install nodejs -y &>>$LOG_FILE_NAME
VALIDATE $? "installing backend"

id expense &>>$LOG_FILE_NAME
if [ $? -ne 0 ]
then
    useradd expense &>>$LOG_FILE_NAME
    VALIDATE $? "adding expense user"
else
    echo -e "expense user already exists.. $Y SKIPPING $N"
fi

mkdir -p /app  &>>$LOG_FILE_NAME
VALIDATE $? "creating app directory"

curl -o /tmp/backend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-backend-v2.zip &>>$LOG_FILE_NAME
VALIDATE $? "downloading backend zip file"

cd /app
rm -rf /app/*

unzip /tmp/backend.zip &>>$LOG_FILE_NAME
VALIDATE $? "unziping the backend file"

npm install &>>$LOG_FILE_NAME
VALIDATE $? "installing the supporting libraries"

cp /home/ec2-user/shellscript/backend.service /etc/systemd/system/backend.service

dnf install mysql -y &>>$LOG_FILE_NAME
VALIDATE $? "installing sql client"

mysql -h mysql.pranayaws.site -u root -pExpenseApp@1 < /app/schema/backend.sql &>>$LOG_FILE_NAME
VALIDATE $? "setting up schema and tables"

systemctl daemon-reload &>>$LOG_FILE_NAME
VALIDATE $? "daemon reload"

systemctl restart backend &>>$LOG_FILE_NAME
VALIDATE $? "restart backend"

systemctl enable backend &>>$LOG_FILE_NAME
VALIDATE $? "enable backend"