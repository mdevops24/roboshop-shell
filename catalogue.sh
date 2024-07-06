source common.sh
component=catalogue
NODEJS

PRINT Install mongodb client
dnf install mongodb-mongosh -y &>>$LOG_FILE
if [ $? -eq 0 ]; then
     echo SUCCESS
  else
     echo FAILED
  fi

PRINT Load master data
mongosh --host mongo.dev.mdevops24.online </app/db/master-data.js &>>$LOG_FILE
if [ $? -eq 0 ]; then
     echo SUCCESS
  else
     echo FAILED
  fi
