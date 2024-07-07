source common.sh
component=frontend

PRINT Disable Nginx default version...
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

PRINT Remove old contenet
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
STAT $?

PRINT Download Application contenet
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>>$LOG_FILE
STAT $?

PRINT Extract Application content
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>>$LOG_FILE
STAT $?

PRINT Enable,Start Nginx
systemctl enable nginx &>>$LOG_FILE
systemctl start nginx &>>$LOG_FILE
STAT $?