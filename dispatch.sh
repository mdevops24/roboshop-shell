source common.sh
component=payment
app_path=/app

PRINT Install GoLang
dnf install golang -y &>>$LOG_FILE
STAT $?

APP_PREREQ

cd /app
PRINT download the dependencies  build the software
go mod init dispatch  &>>$LOG_FILE
go get                &>>$LOG_FILE
go build              &>>$LOG_FILE
STAT $?

SYSTEMD_SETUP