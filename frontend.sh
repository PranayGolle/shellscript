#!/bin/bash

source ./source.sh

CHECK_ROOT
mkdir -p /var/log/shellscript-logs

dnf install nginx -y &>>LOG_FILE_NAME
VALIDATE $? "installing nginx"

systemctl enable nginx &>>LOG_FILE_NAME
VALIDATE $? "enabling nginx"

systemctl start nginx &>>LOG_FILE_NAME
VALIDATE $? "starting nginx"

rm -rf /usr/share/nginx/html/* &>>LOG_FILE_NAME
VALIDATE $? "removing older content"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip &>>LOG_FILE_NAME
VALIDATE $? " dowloading latest updates"

cd /usr/share/nginx/html &>>LOG_FILE_NAME
VALIDATE $? "moving to html folder"

unzip /tmp/frontend &>>LOG_FILE_NAME
VALIDATE $? "unzip the dowloaded content"

systemctl restart nginx &>>LOG_FILE_NAME
VALIDATE $? "restarting the nginx"