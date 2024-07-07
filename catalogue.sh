source common.sh
component=catalogue
app_path=/app

NODEJS

PRINT Install mongodb client
dnf install mongodb-mongosh -y &>>$LOG_FILE
STAT $?

PRINT Load master data
#mongosh --host mongo.dev.mdevops24.online </app/db/master-data.js &>>$LOG_FILE
mongosh --host localhost </app/db/master-data.js &>>$LOG_FILE
STAT $?

