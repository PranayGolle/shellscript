#!/bin/bash

source ./source.sh

CHECK_ROOT

dnf install mysql-server -y &>>$LOG_FILE_NAME
VALIDATE $? "Installing Mysql server"

systemctl enable mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Enabling Mysql server"

systemctl start mysqld &>>$LOG_FILE_NAME
VALIDATE $? "Starting Mysql Server"

mysql -h mysql.pranayaws.site -u root -pExpenseApp@1 -e 'show databases;' &>>$LOG_FILE_NAME

if [ $? -ne 0 ]
then
    echo "MySql Root password not set" &>>$LOG_FILE_NAME
    mysql_secure_installation --set-root-pass ExpenseApp@1
    VALIDATE $? "Setting root password"
else
    echo "MySql Root password already given.... SKIPPING"
fi