source common.sh
component=redis

PRINT Disable old redis
dnf module disable redis -y  &>>$LOG_FILE
STAT $?

PRINT Enable redis 7
dnf module enable redis:7 -y  &>>$LOG_FILE
STAT $?

PRINT Install redis
dnf install redis -y  &>>$LOG_FILE
STAT $?

PRINT Edit redis.conf to 0000 and preotected-mode
sed -i -e '/^bind/ s/127.0.0.1/0.0.0.0/' /etc/redis/redis.conf -e '/protected-mode/ c protected-mode no' &>>$LOG_FILE #to replace to 0.0.0.0  &>>$LOG_FILE
STAT $?

PRINT Enable and start redis
systemctl enable redis  &>>$LOG_FILE
systemctl restart redis &>>$LOG_FILE
STAT $?