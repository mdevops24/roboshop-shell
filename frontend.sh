source common.sh
component=frontend
app_path=/usr/share/nginx/html

PRINT Disable Nginx default version
dnf module disable nginx -y &>>$LOG_FILE
STAT $?

PRINT Enable Nginx 24 version
dnf module enable nginx:1.24 -y &>>$LOG_FILE
STAT $?

PRINT Install Nginx
dnf install nginx -y &>>$LOG_FILE
STAT $?

PRINT Copy nginx.conf file...
cp nginx.conf /etc/nginx/nginx.conf &>>$LOG_FILE
STAT $?

APP_PREREQ

PRINT Enable,Start Nginx
systemctl enable nginx &>>$LOG_FILE
systemctl restart nginx &>>$LOG_FILE
STAT $?