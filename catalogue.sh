source common.sh
component=catalogue

NODEJS

PRINT Install mongodb client
dnf install mongodb-mongosh -y &>>$LOG_FILE
STAT $?

PRINT Load master data
mongosh --host mongo.dev.mdevops24.online </app/db/master-data.js &>>$LOG_FILE
STAT $?

